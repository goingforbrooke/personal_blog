+++
title = "Why Rust"
date = 2024-01-23 

[taxonomies]
tags = ["rust"]
+++

Why did I choose a nascent, apocryphal language to *do the thing*?

<!-- more -->


{{ image(src="crab_trophy.webp",
         alt="A red crab on a beach holding a trophy over its head",
         style="border-radius: 8px;") }}

# Why Rust?

Embarking on an end user project with Rust was no small decision, but I chose it because it's ideal for delivering to users on government networks. Not to mention fun.

> I'm building an ETL tool for law enforcement that puts messy data from search warrant returns into tables. Basically `.* > evidence.csv`

# Delivering to Law Enforcement

My users support the public interest on aging thin clients that run a version of Windows about two versions behind. The last iteration avoided this with a serverside webapp, but the bureaucratic hoops required for a server and an SSH key were too arduous.

# Takin' it Old Skool

There's this legacy process, though, where you submit a binary to the security division for review, and, once it passes, they'll put it up on the internal app store!

> Who knew that you could deliver software this way? 🤯 

# The Fruit Company

{{ image(src="platform_update_meme.jpg",
         alt="Hand drawn meme of update woes on Linux, Windows, and Mac",
         style="border-radius: 8px;") }}

Thin Windows clients represent the majority of government machines, but the taste-makers in specialized investigative divisions tend toward Apple devices. It's tempting to build for these users alone because their machines are more powerful, less locked down, and sequestered to their own corners of the network. I can't stomach it, though, because I know that strategy would hamper the scope that I envisage. Conversely, ignoring these users would slow adoption and eliminate my most valuable feedback channels.

Building for Apple has its own [security hurdles](@/action_universal.md), but what's more concerning are the UX expectations of users on their platform. Installations are quick, UIs are responsive, and there's very low tolerance for fiddling with security permissions. On the bright side, these are surmountable obstacles, which, once solved, will never become issues again. 😏

> Apple *and* Windows it is then, with a consistent UX experience across both platforms. 🙃

# Cloud?

{{ image(src="old_man_yells_cloud.jpeg",
         alt="A Simpsons meme of an old man yelling at a literal cloud",
         style="border-radius: 8px;") }}

For anyone wondering about a cloud solution, know that government folks are suspicious of things that don't run on their own hardware. There's been a big push for Azure adoption, but the security restrictions on these networks make it difficult to do installations, updates, and configuration changes.

> As for [GovCloud](https://aws.amazon.com/govcloud-us/?whats-new.sort-by=item.additionalFields.postDateTime&whats-new.sort-order=desc), I haven't found anyone who's managed to get their hands on it.

# Does Every Platform Dream of Electric Sheep?

Government software vendors include onsite personnel and a service contract with their hefty price tags, but my software's free, so I don't have the capacity to hire more brains or put mine on call. 🧠

That means that we need a multi-platform language that lets us make things to work the first time, and keep working, if we're to manage to delivering anything at all. On top of that, it's gotta offer a path to zero dependencies with high reliability and performance ceilings.

> With a service running in a data center, you can roll back, fix, and roll forward at your convenience. But, when building software that users install, the cost of each mistake is higher -- ["Why Turborepo is migrating from Go to Rust"](https://vercel.com/blog/turborepo-migration-go-rust) on Vercel's blog


Those lofty goals goaded me toward the walled gardens with varying degrees of success:

{{ image(src="secret_garden_coding.webp",
   alt="anakin-padme meme lampooning actions ease of use",
   style="border-radius: 8px;") }}

1. Python 🐍

The Snek language implementation was quick 'n dirty, but I was jonesing for strong types past the 25k lines. While it's possible to wrap an interpreter into a Win executable, it's not incredibly straightforward and the resulting package is bulky. Performance considerations also come into account when I consider how difficult it would be to write a performant database and/or indexer on old hardware with Python. Dependencies could solve the technical problem, but a growing number of government shops will check them against known CVEs. With low severity CVEs receiving as much scrutiny as high severity ones, every `import` carries a sizable risk.

2. Java ☕️

The JVM's great when you can rely on a recent (~6 years) version being available on your user's machine, but that's rarely the case. More importantly, the oldest version among all of my customers would become the floor for the others. I also have reservations about memory usage that stem from the [`-Xms` and `-Xmx` nonsense](https://stackoverflow.com/questions/14763079/what-are-the-xms-and-xmx-parameters-when-starting-jvm) that I encountered in my [ELK](https://www.elastic.co/elastic-stack) wrangling days.

3. C++, C#, Mono, and C 🏎️

Quick and annoying, but getting a simple prototype onto multiple platforms wasn't a clean operation.

4. Rust 🏆

The Draconian syntax pays off by doing what I want it to do, as fast as I want it done, on every platform that I want it done on. The binaries are small, ask nothing of the OS, and zip onto my user's machine before they know that they've clicked "install." The things that suck are problems that I'm willing, even excited to deal with because the *actually hard problems* of distribution and compatibility problems are largely solved.

And hey, I've gotta admit, it feels pretty badass shipping to a legacy device that's built to run a browser. That is *if* this works, anyway, but hey, nothing risked, nothing gained and it'll be fun along the way. 
