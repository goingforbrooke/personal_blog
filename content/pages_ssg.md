+++
title = "Kill the Mad Scientist! Non-Jekyll Github Pages SSG"
date = 2023-05-10

[taxonomies]
tags = ["cicd", "github_actions"]
+++

My first foray into Github Pages seemed like a warmup. Given how strongly Github [touts](https://web.archive.org/web/20230509160818/https://pages.github.com/) its Jekyll integrations, I assumed that the process would painless. Ruby proved me wrong.

<!-- more -->

# Woes of Ruby

{{ image(src="jekyll_quickstart.png",
         alt="screenshot of Jekyll's quickstart page",
         style="border-radius: 8px;") }}

Jekyll’s quick start page belies the complexity of [properly installing Ruby](https://jekyllrb.com/docs/installation/macos/#install-ruby). It threw a bunch of clutter into my `.zshrc` and installed a bunch of non-standard tools on my machine. Keeping non-standard tools up to date was going to cost me more time down the line, and I still wound up editing HTML/CSS/JS on an unaesthetic theme.

# Zola to the Rescue

I swapped [Jekyll](https://jekyllrb.com) for [Zola](https://www.getzola.org) because I already had Rust on my box and, hey, Rust makes everything better. GitHub suggests [other Static Site Generators (SSGs)](https://github.com/actions/starter-workflows/tree/main/pages) with existing CI workflows, but since I was going off the beaten path, I thought it better to double down on something fresh.

# Curse of the Secret Sauce

Zola comes with a [pre-built workflow](https://www.getzola.org/documentation/deployment/github-pages/) for publishing to Github Pages, but it has to fight with Pages’ secret sauce.

{{ image(src="secret_workflow.png",
         alt="screenshot of a github workflow called pages-build-deployment",
         style="border-radius: 8px;") }}

This is Github’s automatic publishing action for Pages, which isn’t defined in `.workflows` and likes to add itself to projects when repos meet one of the mysterious criteria that define a repo as a Pages repo. This meant that the output from my non-Jekyll SSG would be immediately overwritten by Jekyll’s ill-fated output from the `pages-build-deployment` Action. I navigated to my site’s URL, expecting to see a beautiful Zola-generated site, but found a bare HTML site.

These triggers aren’t defined in Github’s documentation and there’s a good bit of [discourse](https://github.com/shalzz/zola-deploy-action/pull/67#issuecomment-1436766564) about how they [seem impossible to disable](https://stackoverflow.com/a/72743923). The triggers seem to be:

1. naming a repo `{{username}}.githhub.io`
2. setting up Pages in the “Pages” tab of a repo’s settings
3. adding a `.yaml` workflow in `.workflows/` that pushes to the `gh-pages` branch

# Recommended Solutions

To disable Jekyll builds, GitHub [recommends](https://github.blog/2009-12-29-bypassing-jekyll-on-github-pages/) adding an empty `.nojekyll` file “to the root of your pages repo.” Initially, this didn’t work because `.nojekyll` needs to exist at the root of the branch that Pages deploys from. The secret sauce defaults to `gh-pages`, but adding `.nojekyll` to `gh-pages` won’t help because most SSGs blow away the branch's contents on each build. With Zola, I accomplished this by adding `.nojekyll` to `static/` in the `main` branch, which delivered `.nojekyll` to the root of `gh-pages`. Still, the secret sauce paid it no heed and my site was soon overwritten by Jekyll.

> Update (25-1-10): Publishing to Pages [from Actions](https://github.blog/changelog/2022-07-27-github-pages-custom-github-actions-workflows-beta/) instead of from the [`gh-pages` branch](https://github.com/orgs/community/discussions/57010#discussioncomment-6076233) is the preferred way to disable Jekyll builds.

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

# Final Thoughts

Image hosting may become an issue if Github isn’t happy about the number of screenshots that I’m including in my posts. I also groan a little each time I commit an image to Git when it should really be hosted elsewhere. An S3-backed hosting option [like the one for WordPress](https://wpengine.com/support/configuring-largefs-store-transfer-unlimited-data/) would be great, but I get the feeling that I’ll need to code it myself.

[Zola](https://www.getzola.org/documentation/templates/overview/)'s been a gem so far with more features than I know what to do with. I’ve yet to explore nifty things like filtering posts by tags, search indexing, and automatic image resizing. The real upside is that I feel confident in my ability to extend the project with anything else that I could want.

I wonder if I’ve taken my site design too far and created something that won’t appeal to a technical audience. I earnestly want to make a great web experience for my readers, but perhaps a basic HTML site without SSL would’ve sufficed.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">A rare counterexample to the principle of specialization: your site should never seem like it was made by communications people, and the best way to achieve this is for it not to be. This is something founders should continue to micromanage forever.</p>&mdash; Paul Graham (@paulg) <a href="https://twitter.com/paulg/status/1654765304184971264?ref_src=twsrc%5Etfw">May 6, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

For any Microsoft developers reading this, I appreciate what you’ve done so far and I’d like to see your product gain wider adoption so I can use it on enterprise networks in exchange for green slips of paper. The design concepts are solid and I catch glimpses of the simplicity that made (pre-acquisition?) GitHub wonderful. To love Actions, I need well-maintained Actions for popular toolchains. I also need GUI-only controls to move to versioned config files so there’s no backend smoke and mirrors.
