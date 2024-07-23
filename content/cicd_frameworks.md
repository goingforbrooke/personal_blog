+++
title = "Rusty Bespoke CI/CD"
date = 2023-12-21 

[taxonomies]
tags = ["cicd", "rust"]
+++

Rusty options for CI/CD pipelines and why Xtask is best for complex pipelines.

<!-- more -->


{{ image(src="crab_infinite_mirror.webp",
         alt="An orange crab looking into an infinite mirror",
         style="border-radius: 8px;") }}

# Issue

We want to automate the delivery of a desktop app to our users, but we don't have a pre-wrapped solution like [Goreleaser](https://goreleaser.com) to do that for us. [CrabNebula](https://crabnebula.dev) and [Shuttle](https://www.shuttle.rs) have some pretty sweet offerings, but I'd rather put the work into a bespoke solution that'll outlast any company and always be free.

> If anyone's wondering about `build.rs`, it's called *before* compilation for stuff like macro expansion.

# Solution

Options:

1. [🐚 Shell Scripts](#shell-scripts): Automate the commands that we're already running
2. [🐍 Python Scripts](#python-scripts): Automate commands by calling them with Python
3. [📦 Cargo Make](#cargo-make): Automate commands in building blocks
4. [🦀 Xtask Framework](#xtask-framework): Use Rust to write our scripts

# Shell Scripts

Dumping shell history to make a script is nothing new.

```zsh
$ bat ~/.zsh_history > something.zsh
```

I get pretty fed up with dquotes and folow control after 25 lines, which is down from the 100 lines of forbearance that I used to be so proud of. Flow control isn't as bad as YAML (cough cough [Actions](@/crappy_guis.md)), but I'm left wanting the features of a full-bodied language for things like logging and syntax checking.

Building and testing software are long-running operations, so I feel like it saves time if we it get it right on the first try. These time savings compound when we consider the cost of fixing a broken pipeline. We might not update a project for six months, and when we return to it, even the most bulletproof CI/CD pipeline might be broken. In that sad, tense moment, when my mental energies are already depleted and my users are clamoring for a fix, deciphering shell scripts is the last thing I wanna do.

# Cargo Make

[Cargo Make](https://sagiegurari.github.io/cargo-make/)'s Makefiles improve on these scripts by breaking them up into discrete chunks. Combined with strong integration into IDEs like [RustRover](https://www.jetbrains.com/rust/), it's a great solution for 95% of CI/CD problems. Since most of us have used Makefiles before, this is awesome for working with a team. I find it lacking for my use case because it's best suited for short, repeatable actions like checking for syntax errors. Longer operations are cumbersome to manage and we never get away from the issues inherent to shell scripts.

# Python Scripts

What about snek? Python's a bit better, offering sane flow control and friendly syntax, but I don't relish the thought of a multi-language environment. Using libraries for Git and app signing often goes poorly, so I end up using Python to call shell commands and check if they failed. The upside is that it's much easier to parse command output and make decisions based off it-- no dquote nightmares or deeply nested `if`/`then`/`do`/`for`s. Since I'm using another langauge to call shell scripts, why not avoid the cost of a multi-language environment and use Rust to call them instead?

# Xtask Framework

That brings us to [Xtask](https://github.com/matklad/cargo-xtask), which super dope and a little cursed. Rather offer a language or batched scripting, Xtask hijacks [workspaces](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html). These are originally intended for large projects with smaller projects inside of them, but we use them to use a discrete binary for building our code.

Here's [FolSum](https://github.com/goingforbrooke/folsum/tree/main) before and after adding Xtask:

Before:

```text
📂 folsum/ 🟩
├── 📂 src/
├── 📂 target/
├── 📂 tests/
├── Cargo.toml
├── Cargo.lock
├── LICENSE.md
├── README.md
```

After:

```text
📂 folsum/ ✨
├── Cargo.toml ✨🟩
├── Cargo.lock ✨
├── LICENSE.md
├── README.md
├── 📂 folsum/
    ├── 📂 src/ 
    ├── 📂 target/
    ├── 📂 tests/
    ├── Cargo.toml
    └── Cargo.lock
└── 📂 xtask/
    ├── 📂 src/ ✨
    ├── 📂 target/ ✨
    ├── 📂 tests/ ✨
    ├── Cargo.toml ✨
    └── Cargo.lock ✨
```

This lets us use Rust to write CI/CD pipelines for `folsum/` in `xtask/`. Why's the latter called `xtask`? It's just convention, but there's enough momentum behind the name that peeps just might know what you're talking about.

> Check out the [Xtasks](https://github.com/sebastienrousseau/xtasks) crate for script-like helpers for things like copying files.

The new top-level `Cargo.toml` (🟩) configures the workspace.

```toml
[workspace]
members = ["folsum", "xtask",]
resolver = "2"
```

Xtask's drawback is that we need to remember the `--package` flag when we add new crates:

```zsh
$ cargo add dirs --package folsum
```

Xtask lets us run CI/CD operations on our local machine the same way it'll run on the build server, all in a language that we know and love! 🦀🤯🏆
