+++
title = "Reflections on Github Actions"
date = 2023-06-01

[taxonomies]
tags = ["cicd", "github_actions"]
+++

GitHub Actions came onto the scene four years ago with the promise of free Continuous Integration (CI) for public repos. I was eager to use it, but quickly found that the product was too young. Buggy UI elements and the dearth of community workflows made it more of a time sink than it was worth, so I left it with the expectation that the issues would be solved.

<!-- more -->

# Philosophy

{{ image(src="actions_anakin.jpg",
         alt="anakin-padme meme lampooning actions ease of use",
         style="border-radius: 8px;") }}

Hanging over these issues was “the DIY tradeoff,” that is, what price do I pay for using someone else’s tools over my own? With libraries, I carefully weigh the cost of adding a dependency against the cost of writing it myself. On one hand, there’s the chance of getting something that just works without having to put in the work for it. On the other hand, I’ve outsourced a part of my creative process and traded deeper understanding (and satisfaction?) for convenience and speed. Some things, like cryptography, are best left to others, while other things, like cache files, are easy enough to implement myself. With that in mind, when I hire “mercenaries,” I’m careful to weigh their cost against their benefits, even when they’re free.

> [“Mercenaries and auxiliaries are useless and dangerous; and if one holds his state based on these arms, he will stand neither firm nor safe; for they are disunited, ambitious, and without discipline…”](https://www.gutenberg.org/ebooks/1232)

# Goals

When Actions offered “the DIY tradeoff,” I assumed that, given a few years and a few piles of those sweet sweet Microsoft dollars, the kinks had been worked out. I had two use cases:

1. [Automatically update and publish this blog](@/pages_ssg.md) when I push changes to it
2. Build and publish my Rust binary for three different platforms

# Bash?

In my mind, GitHub Actions competes with good ‘ole Bash scripts, which I usually run via Python for [comprehensive output checking](https://stackoverflow.com/a/51950538) when they get reach ten lines.  I try to avoid learning technologies controlled by companies because I’ll probably be around longer than they will. That feels awful, though, having to bring an interpreter into my CI/CD pipeline. I can afford those excesses on my local box, but throwing those practices into a charge-by-the-minute build server seems wrong. While GitHub’s not charging me for public repos, I like to learn skills and habits that work well in enterprise environments.

# Actions: YAML

That brings us to Actions, which challenges my Bash-thon workflow with a seductively less arduous syntax. 

```yaml
name: Build, Bundle, and Publish for macOS
on:
  push:
    branches:
      - main
jobs:
  build:
    runs-on: macos-latest
    env:
      SCCACHE_GHA_ENABLED: "true"
      RUSTC_WRAPPER: "sccache"
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      - name: Set up sccache-cache
        uses: mozilla-actions/sccache-action@v0.0.3
      - name: Install Rust toolchain with M1 chip support
        uses: dtolnay/rust-toolchain@stable
        with:
          toolchain: stable
          targets: aarch64-apple-darwin
```

I’m not the biggest fan of YAML, but it’s a nice JSON alternative for mercurial configs that could use some comments. It really shines when there are only 2-3 layers of nesting, but any deeper than that leaves me pining for hanging braces. [Matrices](https://www.jacobbolda.com/dynamic-matrix-jobs-in-GitHub-actions) also draw my ire because they ask me to use variables in a context bereft of a debugger. These complexity problems compound when jobs are broken into separate files. After just a few days away from my workflows, they looked alien to me. That’s ok for a dedicated DevOps person working on a large team, but since I’m an army of one on these projects, I strive to keep everything hardcoded in as few files as possible.

# Pretty Checkmarks

My favorite advantage over Bash is the interactivity of workflow steps. As each step finishes, these friendly little green check marks pop up.

{{ image(src="actions_steps_checks.png",
         alt="anakin-padme meme lampooning actions ease of use",
         style="border-radius: 8px;") }}

When something fails in a Bash script, I have to visually parse dense log output to find the line that created the error. That’s not problematic for a one-off script, but when my CI build breaks, I want to be pointed to the problem right away. Not to mention it’s plain fun watching the green checks populate in another window after pushing some code. Workflow runs follow the same principle, so it’s easy to diagnose which commit went wrong.

{{ image(src="actions_green_checks.png",
         alt="screenshot of a GitHub Action hanging on a yellow build",
         style="border-radius: 8px;") }}

The problem with these check marks is that sometimes they lie. GitHub puts on a show of being up-to-date with workflow progress, but some steps get out of sync, particularly long-running ones. For example, this yellow dot kept spinning and never turned green while the timer continued to increment, despite the job being long done.

{{ image(src="actions_yellow_build.png",
         alt="anakin-padme meme lampooning actions ease of use",
         style="border-radius: 8px;") }}

After refreshing the page, the green checkmark popped up and the timer corrected itself.

{{ image(src="actions_green_build.png",
         alt="anakin-padme meme lampooning actions ease of use",
         style="border-radius: 8px;") }}

When steps fail, the dense log output makes me wish that I could pipe the output to `grep`, but instead, I end up copy-pasting to Vim.

{{ image(src="actions_dense_logs.png",
         alt="anakin-padme meme lampooning actions ease of use",
         style="border-radius: 8px;") }}

# Broken Actions

Beyond my YAML reservations and state issues, I hoped that I could stand on the shoulders of giants by letting premade Actions do the heavy lifting. GitHub’s [Actions Marketplace](https://github.com/marketplace?type=actions) offers a nice menu for finding Actions, but many of these are broken or outdated. Sorting by “Most installed/starred” narrows the results a bit, but stars aren’t a good indicator of viability.

{{ image(src="marketplace_sort_starred.png",
         alt="anakin-padme meme lampooning actions ease of use",
         style="border-radius: 8px;") }}

For example, many resources recommend `actions-rs`’s Actions to build Rust, which looks to be in good repair on the marketplace.

{{ image(src="actions-rs_marketplace.png",
         alt="anakin-padme meme lampooning actions ease of use",
         style="border-radius: 8px;") }}

The [repo](https://github.com/actions-rs/toolchain) for `actions-rs/rust-toolchain` tells a different story.

{{ image(src="actions-rs_toolchain_age.png",
         alt="anakin-padme meme lampooning actions ease of use",
         style="border-radius: 8px;") }}

Running the action works well enough, but its log output is riddled with deprecation errors. A good internet citizen would fork, update, and PR, but…

{{ image(src="actions-rs_language.png",
         alt="anakin-padme meme lampooning actions ease of use",
         style="border-radius: 8px;") }}

[`rust-toolchain`](https://github.com/dtolnay/rust-toolchain) is a wonderful replacement.

Automating releases seems like low-hanging fruit, but Action pages aren’t forthcoming with the release philosophies that back them. In the spirit simplicity, I wanted a release-on-push Action tied to the `main` branch so every merge to `main` would generate a new release. Generating release notes [from PRs](https://github.com/marketplace/actions/release-drafter) and [commit messages](https://github.com/marketplace/actions/release-please-action) looked cool, but I prefer to err on the side of simplicity for initial implementations. Not to mention the potential rabbit hole of needing to learn a [new format for my commit messages](https://www.conventionalcommits.org/en/v1.0.0/).  

[GH Release](https://github.com/marketplace/actions/gh-release) looked like my ticket, but I [wrongly assumed](https://github.com/softprops/action-gh-release/issues/20#issuecomment-533386013) that that [tag gates](https://github.com/marketplace/actions/gh-release#-limit-releases-to-pushes-to-tags) could be disabled.

> “Typically usage of this action involves adding a step to a build that is gated pushes to git tags”

I have nothing against `git tag` and `git push --tags`, but they’re easy steps to forget. Instead, if the GitHub version mirror’s `version` in `Cargo.toml`, then the workflow could later be enhanced with automatic SemVer incrementation.

{% mermaid_diagram(title="Branch Prefix Triggers") %}
flowchart LR
    last_merged_prefix_feat["`last merged branch prefix: **feat/**`"]
    last_merged_cmd_minor["`cargo set-version --bump **minor**`"]
    last_merged_prefix_fix["`last merged branch prefix: **fix/**`"]
    last_merged_cmd_patch["`cargo set-version --bump **patch**`"]

    last_merged_prefix_feat --> last_merged_cmd_minor
    last_merged_prefix_fix --> last_merged_cmd_patch
{% end %}

GH Release doesn’t offer an easy way to `git tag`, but [Create Release](https://github.com/marketplace/actions/create-release) [does quite nicely](https://github.com/goingforbrooke/directory_summarizer/blob/eecbd75d891b4ae7b32ec113dd5af07e28ee3eae/.github/workflows/build_macos.yml#L42). I wish that I had the decision information to start with Create Release before I wandered through the other release Actions.

# Final Thoughts

Actions need the same scrutiny for maintenance and citizenship that libraries do. Unlike a function definition in an API’s documentation, you don’t know what an Action will do before you try it, and trying it involves a lot of waiting and refreshing between iterations. They aren’t as simple as they seem and I’d hesitate to add them to other projects.

I’m happy with the results because I feel confident that my invisible cloud goblins will buy me more development time than it cost me to make them. That is unless they break before the “break-even point.”

Overall, my feelings are best summarized by my mentor’s reaction to my tale. “Hmmm,” he said, smiling cheesily, “well at least it’s free.”
