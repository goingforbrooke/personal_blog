+++
title = "Un-Practices in Github Actions"
date = 2023-10-23

[taxonomies]
tags = ["cicd", "github_actions"]
+++

GitHub Actions has little the way of best practices, but here are some strategies that *don't* work.

<!-- more -->

# Issue

{{ image(src="grinding_cogs.png",
         alt="Metal cogs grinding against each other with debris and sparks being thrown around",
         style="border-radius: 8px;") }}

There's no "right" way to do develop something, but some of my favorite languages and libraries declare their ethos up front, that I might build with their philosophy in mind.

> The [Zen of Python](https://peps.python.org/pep-0020/) and [Go Proverbs](https://go-proverbs.github.io) come to mind.

While GitHub has guides for [usage](https://docs.github.com/en/actions/guides) and [security hardening,](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions) I haven't found documentation on best practices. In the mean time, here some are some strategies worth avoiding.

1. [Step Granularity](#step-granularity)
2. [YAML Control Flow](#yaml-control-flow)

## Step Granularity

I tried [separating concerns](https://en.wikipedia.org/wiki/Separation_of_concerns) by defining each thing-to-do in a discrete [step](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idsteps). I hoped that this would make the CI/CD pipeline easier to debug and enhance, but found the opposite to be true.

In my code, I like to separate the decision about what to do from actually doing the thing. That way, if one of something fails, it's easier to find the fault. That means that we need to store the decision in a variable and use that variable in the following step. Variables in Actions don't persist between steps unless you load them into `$GITHUB_OUTPUT`, making shell the lingua franca of Actions. Copping out to Python could help here, but I'd hate to pay for pulling an interpreter into every CI/CD invocation. So, we regress to [run](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsrun)ning shell commands and adopt the drawbacks of both shell and Actions.

For example, I wanted to fix a bug in [FolSum’s](https://github.com/goingforbrooke/folsum) CSV export where column headers were labelled incorrectly. The current version (on the `main` branch) was `v2.1.0`. I branched off of the development branch with `git sw dev; git swc fix/export_headers`, fixed the bug, and merged the fix back into the development branch with `git sw dev; git merge —no-ff fix/export_headers`. Normally, the pipeline would've incremented the minor version from `v2.1.0` to `v2.2.0`, but I wanted it to change from `v2.1.0` to `v2.1.1`, implying that the release change was a bug fix, not a feature.

To accomplish this, I needed a conditional step that uses the name of the last branch that was merged to `dev`. If it starts with `fix/`, then the patch version would increment. Otherwise, the minor version would increment. It begins with getting the name of the last branch merged to `dev` (*thanks ChatGPT*).

```bash
$ user@host: git log dev --merges --pretty=format:"%s" | sed -n 's/^Merge branch \'\''\(.*\)'\'' into dev$/\1/p' | head -n 1
```

Then I needed to use this branch name to conditionally change the version. To accomplish this, I could follow ChatGPT’s advice and do it in one [step](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idsteps).

```yaml
- name: Increment minor version in Cargo.toml if on main branch
  # Gate version bumping to only happen on main branch.
  if: github.ref == 'refs/heads/main'
  run: |
    # Get the name of the last merged branch into the `dev` branch.
    LAST_MERGED_BRANCH=$(git log --merges -n 1 --pretty=format:"%s" dev | sed -n 's/^.*Merge branch '\''\([^'\'']*\)'\'' into dev.*/\1/p')
    
    # Check if the branch name starts with "fix/".
    if [[ $LAST_MERGED_BRANCH == fix/* ]]; then
      # If branch starts with "fix/", then increment the patch version.
      cargo set-version --bump patch
    else
      # Otherwise, increment the minor version.
      cargo set-version --bump minor
    fi
```

The trouble here is that `run` combines two discrete tasks:

1. Getting the name of last branch that merged to `dev`
2. Using the name of the last branch merged to `dev` to increment the minor/patch version.

Each step could fail, so I’d like to see a green check mark and the output of each step when I’m debugging issues. Otherwise, it’s just a Bash script that I can’t debug locally.

> It might be possible to speed up the debugging loop by running Actions locally with [`act`](https://github.com/nektos/act) or [self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners). I tried `act` for a bit, but gave up after running into compatibility issues with macOS or M1 chips-- I'm not sure which. I haven't tried self-hosted runners, but my initial findings suggested that they're not capble of building universal macOS binaries.

Getting the merged branch name in a discrete step means that I need to make it available to the next step with [outputs](https://docs.github.com/en/actions/using-jobs/defining-outputs-for-jobs).

```yaml
- name: Get current SemVer version from Cargo.toml
  id: get_current_semver
  run: echo "semver=v$(cargo metadata --format-version 1 | jq -r '.packages | .[] | select(.name=="${{ steps.get_repo_name.outputs.repo_name }}") | .version')" >> "$GITHUB_OUTPUT"
```

The key piece here is `echo “🏷️=$(🪄)" >> "$GITHUB_OUTPUT”`
- 🪄 extracts the `version` from `Cargo.toml`
- 🏷️ is accessible in later steps via `”${{ steps.👟.outputs.🏷️ }}”`.
- 👟 is the name of the step set by `id`, which is `get_current_semver` in the snippet above.

> The `v` prefix is also removed.

The `version` extracted from `Cargo.toml` is later accessed with `steps.get_current_semver.outputs.semver` in the `Commit minor version bump` step.

```yaml
- name: Commit minor version bump
  uses: stefanzweifel/git-auto-commit-action@v4
  with:
    file_pattern: Cargo.toml
    commit_message: Increment minor version from ${{ steps.get_current_semver.outputs.semver }} to ${{ steps.get_bumped_semver.outputs.semver }}
```

This feels like a needlessly complicated `export`, which, applied to this issue, looks like this.

```yaml
- name: Get the last branch that was merged into the `dev` branch
  id: get_last_dev_merge
  run: echo "branch_name=$(git log dev --merges --pretty=format:"%s" | sed -n 's/^Merge branch \'\''\(.*\)'\'' into dev$/\1/p' | head -n 1)" >> "$GITHUB_OUTPUT"
- name: Decide whether to bump the minor or patch version
  id: decide_bump_type
  run: | 
    # If the last branch merged with `dev` starts with "fix/"...
    if [[ ${{ steps.get_last_dev_merge.outputs.branch_name }} == fix/* ]]; then
      # ... then increment the patch version.
      echo “bump_type=patch" >> "$GITHUB_OUTPUT"
    else
      # Otherwise, assume that the minor version needs incrementation.
      echo “bump_type=minor" >> "$GITHUB_OUTPUT"
    fi
```

Adding this change took an inordinate amount of time. With descriptive step names, I quickly found the step that needed to be modified, but needed to re-read the rest of the pipeline in order to understand the implications of this change. Debugging shell code's annoying enough on my local machine, but doing it through a web browser with spin-up delays made it much worse. Despite the work that it took to divide the original step, this code block's no easier to debug or enhance.

## YAML Control Flow

These shortcomings are exacerbated by YAML flow control, which adds a behavioral layer that's implicit rather than explicit.

For example, the project uses branch push triggers to kick off the build process. Different branch prefixes [trigger different sets of tasks](@/versioning_version.md), but without implicit flow control, it's hard to keep these tasks from colliding. Branches that don’t match `feat/*` or `fix/*` should trigger a minor version bump while `cicd/*` branches should *act* like they're doing a minor version bump without actually doing so. They [want to run on each commit](https://github.com/goingforbrooke/folsum/blob/645604c6ea87394f0ae4bf6c224e3570b8ed04c0/.github/workflows/build_macos.yml#L6) and need to be reigned in by a smattering of `if` conditionals.

```yaml
if: github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/heads/cicd')
```

I'm not thrilled with having these scattered about my code, but YAML doesn't equip us with `if`/`case`/`match` statements. This makes changes difficult, requiring me to re-learn my pipeline's quirks each time. I pay double for mistakes because I can’t run things locally to test them, not to mention the annoyance of tabbing over to my browser to hit reload on-that-thing-that-just-might-work-this-time.

I considered separating these decisions into [jobs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobs) so I could debug with snazzy [visualization graphs](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/using-the-visualization-graph). That would significantly increase the complexity of the pipeline by deepening into vendor lock-in, making more YAML whitespace issues, and pulling more of my debugging workflow into the browser. In private repos, these mistakes cost money.

# Concluding Thoughts 🎬

If I want to run locally and have control flow logic, then I should use a proper programming language to run shell commands. When I started building this pipeline, I estimated that I could build 80% of the functionality in 20 hours with a time-ROI horizon of two months. With more than 80 hours of CI/CD fiddling to reach the 80% mark, I wish that I had taken a different route.

Instead of seeing a CI/CD service that could quickly set up a flexible build pipeline, I should've seen a Bash wrapper that runs on someone else's machine. Building out shell commands in another language (such as Python) seems wasteful, but the money lost on pulling in an interpreter would've been miniscule compared to the cost of the time that was lost. Instead, I'd cram as much as possible into one Python-fuelled step that I can debug and enhance locally.

