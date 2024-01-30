+++
title = "Versioning the Version: Branch-Bumping Cargo.toml"
date = 2023-08-20

[taxonomies]
tags = ["rust", "cicd", "github_actions"]
+++

Version bumping’s the gateway to a smooth CI/CD process and [branch naming conventions](https://github.com/goingforbrooke/folsum#branch-naming-conventions) make it happen behind the scenes.


<!-- more -->

# Issue 🧐

{{ image(src="bionic_tree.png",
         alt="Naturally-colored tree inlaid with circuitry designs.",
         style="border-radius: 8px;") }}

Git tags are a popular way to version software and trigger CI/CD pipelines, but they exist in VCS-land, a separate dimension from code. I usually forget to tag commits for the CI/CD pipeline, and even then I find myself routinely refreshing my knowledge of the difference between [lightweight and annotated tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging). If I manage to get those steps right without messing up the number, then I forget to add `—tags` to `git push`. At each step, the tags have the opportunity to get out of sync with the code base.

Much of this can be avoided with some combination of [Git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks), [Git aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases), and client-side scripts, but implementations featuring these tools tend to be more stick than carrot. By the time I `git push`, my mind’s already working on the next step, and interrupting that process with a pedantic message pulls me out of the groove.

Since I’m dumb, I need a system that’s smarter than I am.

# Solution 🪄

`Cargo.toml` furnishes us with `version`, and we use it as the source of truth, *versioning the version* to the delight of recursive wording fans everywhere. This integrates with the existing Cargo ecosystem and provides an escape hatch for CI/CD pipelines that use Git tags. It’s easier to create a tag from a file than the other way around.

# Features ✨ and Fixes 🪲

Merging to the `main` branch triggers a release, which builds a macOS binary and [decides](https://github.com/goingforbrooke/folsum/blob/645604c6ea87394f0ae4bf6c224e3570b8ed04c0/.github/workflows/build_macos.yml#L105-L115) whether to bump the [minor or fix version](https://semver.org). This decision depends on the prefix of the last branch that was merged to `dev`. If it was `fix/`, then the fix version’s incremented, but if it was `feat/`, then the minor version’s incremented.

```yaml
- name: Decide whether to bump the minor or patch version
  id: decide_bump_type
  run: | 
    # If the last branch merged with `dev` starts with "fix/"...
    if [[ "${{ steps.get_last_dev_merge.outputs.branch_name }}" == fix/* ]]; then
      # ... then increment the patch version.
      echo "bump_type=patch"  >> "$GITHUB_OUTPUT"
    else
      # Otherwise, assume that the minor version needs incrementation.
      echo "bump_type=minor" >> "$GITHUB_OUTPUT"
    fi
```

# Version Bumping ⬆️

Version bumps are [performed](https://github.com/goingforbrooke/folsum/blob/645604c6ea87394f0ae4bf6c224e3570b8ed04c0/.github/workflows/build_macos.yml#L116-L120) with [Cargo Edit’s](https://crates.io/crates/cargo-edit) `cargo set-version —bump`.

> I’m using the [xtask framework](https://github.com/matklad/cargo-xtask/) in this example, so the eponymous binary source inside the workspace is specified with `—package`.

```yaml
- name: Increment minor/patch version
  # Gate version bumping to only happen on main branch and CI/CD branches.
  if: github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/heads/cicd')
  # Use Cargo Edit to increment the minor/patch version of the project (and not xtask) in Cargo.toml.
  run: cargo set-version --bump ${{ steps.decide_bump_type.outputs.bump_type }} --package ${{ steps.get_repo_name.outputs.repo_name }}
```

Using a crate to accomplish `sed`'s job is overkill, but Cargo Edit’s useful later in the pipeline and moves us one step closer toward a self-contained bundling solution. Admittedly, it doesn’t provide a way to extract the version, so we have to [fall back on the shell with `jq`](https://github.com/goingforbrooke/folsum/blob/645604c6ea87394f0ae4bf6c224e3570b8ed04c0/.github/workflows/build_macos.yml#L94-L96).

```yaml
- name: Get current SemVer version from Cargo.toml
  id: get_current_semver
  run: echo "semver=v$(cargo metadata --format-version 1 | jq -r '.packages | .[] | select(.name=="${{ steps.get_repo_name.outputs.repo_name }}") | .version')" >> "$GITHUB_OUTPUT"
```

# Afraid to Commit 💔

The pipeline then commits the SemVer bump in `Cargo.toml` to the `main` branch. I’m not a fan of this because (a) committing changes directly to `main` violates my merging practice and (b) introduces unverified commits into the repo.

a. In the first issue, we sacrifice form for function because the simplicity gained by *breaking the rules* outweighs the cost of having another (`build`) branch to keep track of. This comes with the burden of remembering to `git pull` the `main` branch before manually doing a major version bump.

b. The second issue’s caused by the commit GitHub Action lacking a verification signature, which can be remedied by using a [different action](https://github.com/marketplace/actions/verified-commit). Our threat model doesn’t require a column of pretty green “Verified” marks, but supply chain security’s a growing concern and I enjoy cryptographically stamping “mine” everywhere.

# Fixing the Fixer 👩🏼‍⚕️

The `cicd/` prefix plays a special role by offering a safe place to troubleshoot the pipeline itself. Builds and version bumps fire as if every commit was a merge to `main`, but only [draft releases](https://docs.github.com/en/free-pro-team@latest/rest/releases/releases?apiVersion=2022-11-28#create-a-release) are created. These are [invisible to users](https://docs.github.com/en/free-pro-team@latest/rest/releases/releases?apiVersion=2022-11-28#list-releases) and won’t cause build failures if a release name already exists. This makes it easy to play with the pipeline out of band without soiling the user’s experience or blocking other developers.

# Room for Improvement 📈

The pipeline’s core logic could be improved by appending the short commit hash to the end of the SemVer. Finding the merge commit for broken builds would be much faster and the pipeline wouldn’t fail due to a (SemVer-based) release name already existing. On the other hand, failing this way makes version bump flow control easier to debug by giving a plaintive voice to unexpected behavior. I’d rather fail to release than ship a mislabeled update to users. The latter’s hard to notice and harder to fix.

Cooperating with other developers under this model would also be difficult because there are no PRs or branch rules to enforce the `feat/` -> `dev` -> `main` merge workflow. This is because I’m the only one on these projects and I haven’t gotten around to it yet.

{{ image(src="han_solo_shrug.jpg",
         alt="Han Solo shrugging and smiling.",
         style="border-radius: 8px;") }}

Since the pipeline runs on each commit pushed to `cicd/` branches, too much learning or fixing could get expensive in a private repo. A [self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) might alleviate this, but I haven’t bothered trying because I’m afraid that it’s not a faithful reproduction of GitHub’s environment. Even if I’m wrong in that assumption, I’d rather spend time migrating to [Xtask](https://github.com/matklad/cargo-xtask).

# Concluding Thoughts 🎬

Leaning on `Cargo.toml` keeps things simple and clean while keeping Ferris at the center of my galaxy. It’s awesome that I can key this capability off branch-naming conventions that I’ve already built habits for, but I don’t know well my bible sits in the hands of others. At its best, this model strains the capabilities of GitHub Actions due to poor flow control.
