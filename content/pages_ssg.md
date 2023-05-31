+++
title = "Kill the Mad Scientist! Non-Jekyll Github Pages SSG"
date = 2023-05-10

[taxonomies]
tags = ["cicd", "github actions"]
+++

My first foray into Github Pages seemed like a warmup. Given how strongly Github [touts](https://web.archive.org/web/20230509160818/https://pages.github.com/) its Jekyll integrations, I assumed that the process would painless. Ruby proved me wrong.

<!-- more -->

# Woes of Ruby

{{ image(src="jekyll_quickstart.png",
         alt="screnshoot of Jekyll's quickstart page",
         style="border-radius: 8px;") }}

Jekyll’s quick start page belies the complexity of [properly installing Ruby](https://jekyllrb.com/docs/installation/macos/#install-ruby). It threw a bunch of clutter into my `.zshrc` and installed a bunch of non-standard tools on my machine. Keeping non-standard tools up to date was going to cost me more time down the line, and I still wound up editing HTML/CSS/JS on an unaesthetic theme.

# Zola to the Rescue

I swapped [Jekyll](https://jekyllrb.com) for [Zola](https://www.getzola.org) because I already had Rust on my box and, hey, Rust makes everything better. Github suggests [other Static Site Generators (SSGs)](https://github.com/actions/starter-workflows/tree/main/pages) with existing CI workflows, but since I was going off the beaten path, I thought it better to double down on something fresh.

# Curse of the Secret Sauce

Zola comes with a [pre-built workflow](https://www.getzola.org/documentation/deployment/github-pages/) for publishing to Github Pages, but it has to fight with Pages’s secret sauce.

{{ image(src="secret_workflow.png",
         alt="screenshot of a github workflow called pages-build-deployment",
         style="border-radius: 8px;") }}

This is Github’s automatic publishing action for Pages, which isn’t defined in `.workflows` and likes to add itself to projects when repos meet one of the mysterious criterion that define a repo as a Pages repo. This meant that the output from my non-Jekyll SSG would be immediately overwritten by Jekyll’s ill-fated output from the `pages-build-deployment` Action. I navigated to my site’s URL, expecting to see Zola, and found with a bare HTML version of my site. 

These triggers aren’t defined in Github’s documentation and there’s a good bit of [discourse](https://github.com/shalzz/zola-deploy-action/pull/67#issuecomment-1436766564) about how they [seem impossible to disable](https://stackoverflow.com/a/72743923). They triggers seem to be:

1. naming a repo `{{username}}.githhub.io`
2. setting up Pages in the “Pages” tab of a repo’s settings
3. adding a `.yaml` workflow in `.workflows/` that pushes to the `gh-pages` branch

# Recommended Solutions

To disable Jekyll builds, Github [recommends](https://github.blog/2009-12-29-bypassing-jekyll-on-github-pages/) adding an empty `.nojekyll` file “to the root of your pages repo.” Initially, this didn’t work because `.nojekyll` needs to exist at the root of the branch that Pages is deploying from. The secret sauce defaults to `gh-pages`, but adding `.nojekyll` to `gh-pages` won’t help because most SSGs blow away the branch's contents on each build. With Zola, I accomplished this by adding `.nojekyll` to `static/` in the `main` branch, which delivered `.nojekyll` to the root of `gh-pages`. Still, the secret sauce paid it no heed and my site was soon overwritten by Jekyll.

# My Solution

To fix the problem, I had to excise Actions from the repo. 

First, I ignored the recommendation to use Actions for “customizing my build process” in Repo -> Settings -> Pages -> Build and Deployment. Instead, I restricted Pages to branch deployments.

{{ image(src="branch_deploy.png",
         alt="screenshot of a github workflow called pages-build-deployment",
         style="border-radius: 8px;") }}

Second, I disabled all Actions with the exception of workflows defined by me. Choosing “Allow goingforbrooke actions and reusable workflows” doesn’t stop the Pages secret sauce, so I allowed all of the repo’s workflows that match `*`. This is found in Repo -> Settings -> Actions -> General -> Actions Permissions.

{{ image(src="actions_permissions.png",
         alt="screenshot of a github workflow called pages-build-deployment",
         style="border-radius: 8px;") }}

# Takeaways

With that, I have a blog that automatically updates when I push to it. 🎉

If you’d like to use anything that I’ve built here, feel free to copy-pasta my workflow for [automatically pushing a website](https://github.com/goingforbrooke/personal_blog/blob/main/.github/workflows/publish_site.yaml). It’s [Zola’s deploy action](https://github.com/shalzz/zola-deploy-action) with the [exception](https://github.com/goingforbrooke/personal_blog/blob/b356b5af56c525eb570be10e1c37911a2d4a298b/.github/workflows/publish_site.yaml#LL12C23-L12C23) of changing `zola-deploy-action` to `master`. This prevents an [issue](https://github.com/shalzz/zola-deploy-action/issues/71#issuecomment-1501488817) in Zola.