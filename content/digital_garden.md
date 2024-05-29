+++
title = "My Digital Garden"
date = 2023-09-28

[taxonomies]
tags = ["notes", "half-baked"]
+++

Organized lists of stuff that I think is cool.

<!-- more -->

# Purpose

{{ image(src="garden_library.png",
         alt="Library with fruits, vegetables, and herbs growing out of the shelves.",
         style="border-radius: 8px;") }}

Inspired by [Gwern's blog](https://gwern.net/about#development), I want to make a place online for links that I think are awesome. If I'm successful in building this [digital garden](https://maggieappleton.com/garden-history), then it'll be opinionated, weird, and disorganized. Maybe this [isn't a digital garden at all](https://brainbaking.com/post/2021/10/are-digital-gardens-blogs/). Anything too polished would be more [stock than flow](https://snarkmarket.com/2010/4890/), and might burden me with the appearance of agreeing with the content that these links lead to. Rather, these pieces of information are targets for synthesis.

# Links

- blogs
  - [Armin Ronacher](https://lucumr.pocoo.org)
  - [factorio](https://factorio.com/blog/)
  - [Kenneth Reitz](https://kennethreitz.org/essays)
  - [Paul Graham](http://paulgraham.com/articles.html)
- books
  - [Make Time by Jake Knapp and John Zeratsky (2018)](https://maketime.blog)
  - [Rust Atomics and Locks by Mara Bos (2023)](https://marabos.nl/atomics/)
  - [Staff Engineer: Leadership Beyond the Management Track (2021)](https://staffeng.com/book)
  - [The Mythical Man-Month by Frederick P. Brooks, Jr. (1975)](https://en.wikipedia.org/wiki/The_Mythical_Man-Month)
  - [The Pragmatic Programmer by David Thomas and Andrew Hunt (2019)](https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/)
  - [Zero to One (2014) by Peter Thiel](http://paulgraham.com/articles.html)
- CI/CD
  - [branching with Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
    - great for [CI/CD pipelines](@/versioning_version.md)
- concurrency and parallelization
  - [Golang concurrency animations](https://divan.dev/posts/go_concurrency_visualize/)
- development practices
  - [emojis for git messages](https://gitmoji.dev)
        - [JetBrains plugin](https://plugins.jetbrains.com/plugin/12383-gitmoji-plus-commit-button)
  - [interactive latency toy](https://samwho.dev/numbers/?fo)
  - [refactoring guru design patterns catalog](https://refactoring.guru/design-patterns/catalog)
    - credit: [Tim Janus](https://twitter.com/DarthB86) RustNation UK talk
- open source development
  - [awesomeopensource.com](https://awesomeopensource.com)
  - [choosealicense.com](https://choosealicense.com)
  - [keepachangelog.com](https://keepachangelog.com/en/1.0.0/)
  - [makeareadme.com](https://www.makeareadme.com)
- IDEs
  - ideavim
    - [available actions](https://gist.github.com/zchee/9c78f91cc5ad771c1f5d)
    - [awesome `.ideavimrc`](https://www.cyberwizard.io/posts/the-ultimate-ideavim-setup/)
- Python
  - [Black](https://github.com/psf/black)
  - [pipenv](https://github.com/pypa/pipenv)
- Rust
  - [API guidelines](https://rust-lang.github.io/api-guidelines/flexibility.html)
      - [examples should use `?`](https://rust-lang.github.io/api-guidelines/documentation.html#examples-use--not-try-not-unwrap-c-question-mark)
  - [`CARGO*` env vars](https://doc.rust-lang.org/cargo/reference/environment-variables.html#environment-variables-cargo-sets-for-crates)
  - [areweguiyet.com](https://areweguiyet.com)
  - [cargo bundle](https://github.com/burtonageo/cargo-bundle)
  - [cargo edit](https://github.com/killercup/cargo-edit)
  - [CLI recommendations](https://rust-cli-recommendations.sunshowers.io)
      - [clap subcommand structure](https://rust-cli-recommendations.sunshowers.io/handling-arguments.html) from [@rain](https://sunshowers.io)
  - documentation
    - [common documentation section headers](https://web.mit.edu/rust-lang_v1.25/arch/amd64_ubuntu1404/share/doc/rust/html/book/first-edition/documentation.html#writing-documentation-comments)
    - [RFC 505: common documentation conventions](https://github.com/rust-lang/rfcs/blob/master/text/0505-api-comment-conventions.md)
    - [mdbook-mermaid](https://github.com/badboy/mdbook-mermaid)
      - add [Mermaid](https://mermaid.js.org) charts to MdBook pages
      - [example: build rustdoc, mdbook and deploy to GitHub Pages](https://github.com/nextest-rs/nextest/blob/nextest-runner-0.54.1/.github/workflows/docs.yml) in [@rain's](https://sunshowers.io) Nextest
      - [rustdoc book: how to write good documentation](https://doc.rust-lang.org/rustdoc/how-to-write-documentation.html)
  - [great XML library comparison](https://mainmatter.com/blog/2020/12/31/xml-and-rust/)
  - [Postel's Law](https://en.wikipedia.org/wiki/Robustness_principle)
  - macros
    - [Little Book of Rust Macros](https://veykril.github.io/tlborm/)
    - [yet-undocumented procedural macros](https://doc.rust-lang.org/nightly/reference/procedural-macros.html)
    - [procedural macro blog JetBrains blog post](https://blog.jetbrains.com/rust/2022/03/18/procedural-macros-under-the-hood-part-i/)
- [starred GitHub projects](https://github.com/goingforbrooke?tab=stars)
- terminal goodness
  - [Alacritty](https://github.com/alacritty/alacritty)
  - [versioning dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
  - [`eza`](https://github.com/eza-community/eza)
  - [`fd`](https://github.com/sharkdp/fd)
  - [Neovim](https://github.com/neovim/neovim)
    - [Conquer of Completion](https://github.com/neoclide/coc.nvim)
  - [powerlevel10k](https://github.com/romkatv/powerlevel10k)
  - [ripgrep ("`rg`")](https://github.com/BurntSushi/ripgrep)
  - [zoxide](https://github.com/ajeetdsouza/zoxide)
- web stuff
  - [mf website](https://motherfuckingwebsite.com)
    - spicy thoughts on responsive website design

> I've switched from Midjourney to ChatGPT for generating my header images. So far, I'm a little disappointed with how tame they are. They feel more design-by-committee rather than the zany and unorthodox monstrosities that sail out of Midjourney. For example, the image for this post looks more like a misplaced farmer's market than a library of ideas. I would've preferred something like [this](https://youtu.be/hLljd8pfiFg?si=5o0YAVc1DQGHZIXi).

{{ image(src="globglogabgalab.jpeg",
         alt="A digitally rendered bookworm in a library.",
         style="border-radius: 8px;") }}
