+++
title = "Build and Notarize Universal Rust Binaries for MacOS"
date = 2023-07-28

[taxonomies]
tags = ["cicd", "github_actions", "rust"]
+++

Use a Github Action workflow to build "universal" Rust binaries that work for both MacOS chip architectures.

<!-- more -->

{{ image(src="apple_orange.png",
         alt="two realistic Apple logos in red and yellow",
         style="border-radius: 8px;") }}

# Issue

With MacOS's new M1 chip architecture, there are now two build targets for MacOS: `x86_64-apple-darwin` and `aarch64-apple-darwin`. Rather than ask our users to identify their chip architecture on a product installation page, I prefer to have one binary that works for all installation targets.

{{ image(src="mbp_about_chip.png",
         alt="screenshot of a MacbookPro 'About this Mac' page",
         style="border-radius: 8px;") }}

Apple's happy path uses XCode, but detest using a vendor-specific GUI to ship software on each release. That leaves us with [`lipo`](https://developer.apple.com/documentation/apple-silicon/building-a-universal-macos-binary#Update-the-Architecture-List-of-Custom-Makefiles), which ships with MacOS. [MacOS Runners are expensive](https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions#minute-multipliers), but it's a good start.

Along the way, we need to notarize the binary with Apple so our users don't get a scary installation popup warning that our application might be malware.

# Solution

This Github Workflow creates two binaries, `x86_64-apple-darwin` and `aarch64-apple-darwin` and "smushes them together" with `lipo`. Then it signs and notarizes the resulting binary and bundles it into a `.app` that's ready to be installed. There are some other goodies in here, such as a minor SemVer bump and some build caching to speed things up.

<script src="https://gist.github.com/goingforbrooke/24a36ed60ba97ce9a93c1e0c5036f232.js"></script>

# Kudos

Credit to [Federico Terzi's blog post ](https://federicoterzi.com/blog/automatic-code-signing-and-notarization-for-macos-apps-using-github-actions/) on signing and notarizing MacOS apps with GitHub Actions.
