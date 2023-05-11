+++
title = "Kill the Mad Scientist! Non-Jekyll Github Pages SSG"
date = 2023-05-10

[taxonomies]
tags = ["cicd", "github actions"]
+++

My first foray into Github Pages seemed like a warmup. Given how strongly Github [touts](https://web.archive.org/web/20230509160818/https://pages.github.com/) its Jekyll integrations, I assumed that the process would painless. Ruby proved me wrong.

<!-- more -->

{{ image(src="jekyll_quickstart.png",
         alt="Hello Friend",
         style="border-radius: 8px;") }}

Jekyll’s quick start page belies the complexity of [properly installing Ruby](https://jekyllrb.com/docs/installation/macos/#install-ruby). It threw a bunch of clutter into my `.zshrc` and installed a bunch of non-standard tools on my machine. Keeping non-standard tools up to date was going to cost me more time down the line, and I still wound up editing HTML/CSS/JS on an unaesthetic theme.

### Zola to the Rescue

I swapped [Jekyll](https://jekyllrb.com) for [Zola](https://www.getzola.org) because I already had Rust on my box and, hey, Rust makes everything better. Github suggests [other Static Site Generators (SSGs)](https://github.com/actions/starter-workflows/tree/main/pages) with existing CI workflows, but since I was going off the beaten path, I thought it better to double down on something fresh.

## Curse of the Secret Sauce

Zola comes with a [pre-built workflow](https://www.getzola.org/documentation/deployment/github-pages/) for publishing to Github Pages, but it has to fight with Pages’s secret sauce.

{{ image(src="secret_workflow.png",
         alt="screenshot of a github workflow called pages-build-deployment",
         style="border-radius: 8px;") }}