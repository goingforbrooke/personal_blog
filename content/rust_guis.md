+++
title = "Simple Rust GUIs for Desktop Apps"
date = 2023-11-28

[taxonomies]
tags = ["rust", "GUI"]
+++

A survey of simple Rust GUIs for desktop applications. **Spoiler:** [egui](https://github.com/emilk/egui)'s my favorite.

<!-- more -->

{{ image(src="raclette_sandwich.png",
         alt="Gooey raclette cheese oozing out of a white bread sandwich",
         style="border-radius: 8px;") }}

# Issue

Without a GUI, non-technical users can't use my software and give me feedback on application logic. That impedes the feedback loop necessary to improve my product.

# Motivation

I used to solve this problem with [Flask](https://github.com/pallets/flask)'s HTML templating because it can be easily replaced with a ReactJS frontend as the project grows. In Rust, I'd like a desktop equivalent to the simple GUIs that other systems languages enjoy.

# Goals

1. 📐It should create a consistent experience on Windows, macOS, and Ubuntu without platform-specific changes. WASM's a bonus because it offers the possibility of converting my desktop app to a web app in the future.

2. 🦀 I prefer pure Rust solutions because they simplify compilation and don't inherit the issues of libraries written in other languages. Not to mention it's kinda romantic having top-to-bottom Rust. JavaScript will viewed with great suspicion because I'm sick of it.

3. ✨Above all, UI changes should be trivial so I can focus on what's happening behind the scenes. 

# Non-Goals

1. It [doesn't need to be beautiful](@/crappy_guis.md) because I'm willing to sacrifice much on the altar of simplicity.

2. Web apps don't qualify because they require writing a second interface-- the RESTful API. Each visual change requires code changes in two places, which takes time away from working on core logic.

# Table of Contents

- [🧊Iced: Elm-esque retained mode in async hell](#iced)
- [🎁Tauri: Super wrapper for the ages](#tauri)
- [💖egui: Simple, portable, and fun](#egui)
- [⚛️Dioxus](#honorable-mention-dioxus)
- [🌳Xilem](#honorable-mention-xilem)
- [🗒️Makepad](#honorable-mention-makepad)
- [🛵Slint](#honorable-mention-slint)
- [📚Additional Material](#additional-material)

# Iced

[Iced](https://github.com/iced-rs/iced) offers a unique [model-view-update](https://elmprogramming.com/model-view-update-part-2.html) creation experience that borrows heavily from the [Elm framework](https://elm-lang.org). It offers a [retained](https://nikolish.in/gs-with-iced-1) (as opposed to immediate) mode update system that encourages simplicity by eschewing callbacks. Visual updates are reduced to state changes triggered by enum "messages".

{{ youtube(id="gcBJ7cPSALo?si=JSF3XnMv-1EdbxYg" start="13:01") }}

It felt funky at first, but once I got used to it, adding buttons and changing the layout was incredibly simple. The trouble was the time that it took time to get there.

> One of the main complaints that we get from newcomers to the library is that there is a lack of [documentation](https://docs.rs/iced/0.10.0/iced/index.html). -- [Héctor Ramón](https://github.com/hecrj)

Reading the code was fun, but it made Iced the most time-consuming duplication of my frontend.

> The [book](https://book.iced.rs/) is completely empty currently, so if you want to learn, then you have to read a bunch of code from the examples, which, most of them aren't too simple. -- [Héctor Ramón](https://github.com/hecrj)

Iced was the best-looking library that I explored. The default shapes and colors for buttons and panes are simple and visually pleasing without intruding on the style of Windows, *nix, or macOS. Different enough to be distinct and simple enough to be friendly, the defualt look of Iced made my project look sellable. Any library can be made to look enough like anything, but the prototypes we show to customers and investors often sport a good bit of `create-react-app`.

Using layouts to precisely arrange elements was awesome, and not every library guarantees that ability. I expect I'll miss it dearly as the number of UI elements grows with the project.

{{ image(src="whiskey_glass_ice.png",
         alt="Cubes of ice in a whiskey glass against a dark background",
         style="border-radius: 8px;") }}

Async programming is what drove me from Iced because it demands a high ergonomic price that I wasn't willing to pay. The [function coloring problem](https://without.boats/blog/why-async-rust/) makes it difficult for async code to play nice with sync code, which drove me to rewrite the core logic in async. A zealous measure, but it seemed like the best way to reclaim lost simplicity. The cost of the conversion came to light when I found how involved it was to add new features.

> Async can be avoided by using [`Sandbox`](https://docs.rs/iced/0.10.0/iced/trait.Sandbox.html) instead of [`Application`](https://docs.rs/iced/0.10.0/iced/application/trait.Application.html) to set up the GUI, but it seemed like everything *cool* in [`examples/`](https://github.com/iced-rs/iced/tree/master/examples) required the latter.

This had the side effect of forcing me to choose an [`Executor`](https://docs.rs/iced/0.10.0/iced/trait.Executor.html) much earlier than I would've liked. Before Iced, I was happily coding along with [`channels`](https://doc.rust-lang.org/std/sync/mpsc/fn.channel.html), assuming that a GUI thread would be just another splash in the thread pool. Async constructs and channels *could* coexist peacefully, but simplicity demanded that I centralize control by attaching my core logic to the executor. That sufficed until it blocked WASM compilation targets. Channels, by contrast, needed only [wasm-bindgen-futures](https://docs.rs/wasm-bindgen-futures/latest/wasm_bindgen_futures/) to transparently "fake" multiple threads in the browser.

“Not production ready” is written all over the docs, but Iced never crashed on me. It's a terrific library that deserves more attention than it gets, but I got the impression that adoption would drive me to contributing before long. GUI work don't sing to my passions, though, so I chose to part ways with gratitude and optimistic expectations. I fully expect to use it again in the future.

# Tauri

Not so much a GUI crate as a super-wrapper of sorts, Tauri offers an [Electron](https://www.electronjs.org)esque ["platform webview"](https://youtu.be/XjbVnwBtVEk?si=e5v-cyhWabnn4h23&t=356) that's [easier on system resources](https://www.youtube.com/watch?v=UxTJeEbZX-0&t=233s).

> Electron's the webpage-in-a-box behind Discord, VSCode, Slack, Atom, and Skype.

I hoped to paint some JavaScript over my Rust code and reap the aesthetic benefits of the web. The result would be a quick application that looked great and ran anywhere. I couldn't stomach going back to JavaScript, but the [starter guide](https://tauri.app/v1/guides/getting-started/setup/) made for a fun intro to [Sveltekit](https://learn.svelte.dev/tutorial/introducing-sveltekit).

> "Come for the Rust, but stay for the JS. It's a terrible claim, but basically, what we're trying to do with the API is lower the barrier of entry for people who want the safety guarantees of Rust and the very strict approach to access of the system assets that we can offer from Tauri." -- Denjell

{{ youtube(id="BhmXTi0X7Kg?si=C5cH9eI2kc08qeK1" start="38:20") }}

The Sveltekit intro tracks with the unparalleled [docs](https://tauri.app/v1/guides/) that [Lorenzo Lewis](https://twitter.com/lorenzoilewis) is making [even better](https://beta.tauri.app). He and the other Tauri folks had a warm presence at [RustConf](https://rustconf.com) this year and their partner company [Crab Nebula](https://crabnebula.dev/blog/tauri-partnership) continues to inject love into the Rustacean community.

Developer prioritization culminates in an inspiring CI ecosystem with deployment capabilities approaching that of [goreleaser](https://github.com/goreleaser/goreleaser). My [CI pipelines](@/action_universal.md) borrow heavily from Tauri's example.

<blockquote class="twitter-tweet" data-dnt="true" data-theme="dark"><p lang="en" dir="ltr">4 years ago today, Denjell &amp; Lucas, the cofounders of Tauri, wrote C++ for the last time and decided that <a href="https://twitter.com/rustlang?ref_src=twsrc%5Etfw">@rustlang</a> would be the foundation for what today is the most popular of all <a href="https://twitter.com/hashtag/OSS?src=hash&amp;ref_src=twsrc%5Etfw">#OSS</a> projects of its age on <a href="https://twitter.com/github?ref_src=twsrc%5Etfw">@github</a> written in Rust:<a href="https://t.co/ZhrGKOJHAd">https://t.co/ZhrGKOJHAd</a> <a href="https://t.co/VsyMRwRXmu">pic.twitter.com/VsyMRwRXmu</a></p>&mdash; Tauri (@TauriApps) <a href="https://twitter.com/TauriApps/status/1660938334884036608?ref_src=twsrc%5Etfw">May 23, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


My biggest issue with Tauri was how much it slowed filesystem access. Compared to [egui](#egui), it took far longer to count every file on my machine, probably due to the [file access whitelist](https://tauri.app/v1/api/js/fs/). It's an ambitious standard for security that I'd like to see in other projects, but I really want my Rust code to run unimpeded.

Researching solutions got me lost in the world of [Vite](https://vitejs.dev) and other [WASM](https://webassembly.org)-related stuff. It's fascinating reading, but too esoteric for the simplicity I crave.

By the end of my time with it, I felt that Tauri was focused more on being powered *by* Rust than being *for* Rust. The CI/CD, documentation, and explicit security were wonderful, but those conveniences weren't enough to justify mixing NodeJS into my project. Inspired by [Iced](#iced), I tried [Elm](https://elm-lang.org), but that fun little detour was a weird little Haskell-world unto itself.

# egui

[egui](https://github.com/emilk/egui) has my heart because it's incredibly simple and plays nice with all compilation targets.

{{ embedpage(url="https://www.egui.rs/#demo") }}

The default look won't win any awards, but built-in graphs give us JavaScript-like visualizations that other GUI libraries are only beginning to add. A few [tweaks](https://github.com/emilk/egui#can-i-customize-the-look-of-egui) to the global theme look pretty sweet pretty fast, but it's tedious to [style elements in groups](https://github.com/emilk/egui/issues/3284).

> Best of all, it has a dark theme! 🤯

Given the project's incredible growth over the last year, I'm confident that what doesn't already exist won't be that far off. Project churn in the Rust ecosystem has made it feel more chaotic than it is, but I could always count on [emilk](https://twitter.com/ernerfeldt)'s benevolent care to keep egui alive as other crates fell into disuse.

What egui doesn't have, I'm certain I could add myself. The simplicity you see in the API permeates the project. For instance, the code behind this [hello world example](https://github.com/emilk/egui/blob/0.25.0/examples/hello_world/src/main.rs).

{{ image(src="egui_hello_world.png",
         alt="Screenshot of a simple application with a slider and a picture of Ferris the crab.",
         style="border-radius: 8px;") }}

I left out the boilerplate because the meat of the GUI lives in `update()`. The [immediate approach](https://nikolish.in/gs-with-iced-1) calls `update()` [many times a second](https://github.com/emilk/egui/issues/1109#issuecomment-1013742990), completely redrawing the screen each time 🤣. All that *is* and all that *do* exists in one place.

```rust
impl eframe::App for MyApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        egui::CentralPanel::default().show(ctx, |ui| {
            ui.heading("My egui Application");
            ui.horizontal(|ui| {
                let name_label = ui.label("Your name: ");
                ui.text_edit_singleline(&mut self.name)
                    .labelled_by(name_label.id);
            });
            ui.add(egui::Slider::new(&mut self.age, 0..=120).text("age"));
            if ui.button("Click each year").clicked() {
                self.age += 1;
            }
            ui.label(format!("Hello '{}', age {}", self.name, self.age));

            ui.image(egui::include_image!(
                "../../../crates/egui/assets/ferris.png"
            ));
        });
    }
}
```

Those redraws add some CPU strain, but it's not a big deal if the GUI has its own thread 🧐. Mobile targets stand to suffer the most due to the impact on battery life. I'm hesitant to chalk this up to an intrinsic flaw, though, because optimzation, like [animations](https://github.com/lucasmerlin/hello_egui#experimental-crates), hasn't been explored yet.

> If your GUI is highly interactive, then immediate mode may actually be more performant compared to retained mode. Go to any web page and resize the browser window, and you'll notice that the browser is very slow to do the layout and eats a lot of CPU doing it. Resize a window in egui by contrast, and you'll get smooth 60 FPS at no extra CPU cost. -- [egui docs](https://github.com/emilk/egui/tree/0.25.0#cpu-usage)

<blockquote class="twitter-tweet" data-dnt="true" data-theme="dark"><p lang="en" dir="ltr">It&#39;s fun to use cargo-tally to track adoption of new egui releases <a href="https://t.co/O0WhoKnG7w">pic.twitter.com/O0WhoKnG7w</a></p>&mdash; emilk (@ernerfeldt) <a href="https://twitter.com/ernerfeldt/status/1725153388210385154?ref_src=twsrc%5Etfw">November 16, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

The benefit of barbarous rendering is a crisp response that few have touched since the programs of yore. Clicks register almost presciently, building trust. That is, if my user can ignore the mounting suspicion that they've downloaded a trojan.

Here's how [my project's](https://github.com/goingforbrooke/folsum/tree/main) looking with egui.

> Lowkey the "Summarize" button doesn't work in WASM builds because I haven't dummy files (yet).

{{ embedpage(url="https://www.goingforbrooke.com/folsum/") }}

Layout capabilities are egui's the biggest deficiency it intrinsically forbids the concept of a layout as we know it. Neatly proportioned panes aren't in the cards when you're tossing in elements from the top left to bottom right.

Egui's incredibly portable, happily deploying to Windows and MacOS with no code or dependency changes. The WASM build above was a [starter template](https://github.com/emilk/eframe_template) serendipity and it'll even [fit inside](https://tauri.app/blog/2022/09/19/tauri-egui-0-1/) [Tauri](#tauri) 🤯.

The [README](https://github.com/emilk/egui/blob/master/README.md) comprises most of the docs, though I needed little help beyond the [starter template](https://github.com/emilk/eframe_template/) and a few examples.

# Honorable Mention: Dioxus

{{ image(src="dioxus_wifi_scanner.png",
         alt="Screenshot of a simple wifi scanning application with each network's name, strength, channel, and security.",
         style="border-radius: 8px;") }}

[Dioxus](https://github.com/DioxusLabs/dioxus) is gaining popularity with its React-style component update model. I haven't tried it yet because I'm weary of React's labrinthine update propagations.

The project has incredible documentation and a thriving community that makes me want to procrastinate in GUIland even longer.

# Honorable Mention: Xilem

[Xilem](https://github.com/emilk/egui/blob/master/README.md) looks promising, but it's [more idea](https://www.xilem.dev) than library. It aims to become Rust's definitive UI framework by incorporating lessons from SwiftUI and [Druid](https://github.com/linebender/druid), a popular crate that was discontinued in favor of Xilem. I'm excited to watch [Raph Levien’s](https://mastodon.online/@raph) [vision](https://raphlinus.github.io/rust/gui/2022/05/07/ui-architecture.html) mature into an incredible developer experience.

> Xilem unapologetically contains at its core a lightweight change propagation engine, similar in scope to the attribute graph of SwiftUI, but highly specialized to the needs of UI, and in particular with a lightweight approach to downward propagation of dependencies, what in React would be stated as the flow of props into components. -- [Raph Levien’s](https://mastodon.online/@raph)

# Honorable Mention: Makepad

Like [egui](#egui), [Makepad's](https://github.com/makepad/makepad/) an immediate mode contender.

> "because there's always been this fight between 'how do you make a UI that is designable, and how do you make a UI that's programmable?" -- Rik Arends [@rikarends](https://x.com/rikarends?s=20)

{{ youtube(id="rC4FCS-oMpg?si=qT2ZWRzigA96PsD-" start="20:08") }}

It offers a lot more flashy bits than what's on display here, and the [ironfish synth](https://makepad.nl/makepad/examples/ironfish/src/index.html) is a blast to play around with.

{{ embedpage(url="https://makepad.nl/makepad/examples/simple/src/index.html") }}

The trouble here is that it's not produciton ready (yet).

> "not production ready" [@JanPaul123](https://x.com/JanPaul123?s=20)

# Honorable Mention: Slint

[Slint](https://github.com/slint-ui/slint) has a nice look and seems to [cater to embedded systems](https://madewithslint.com), which I hoped would translate to portability. The creators wanted to move on from Qt to mouse-driven UI modelling that could then be wired up to code.

{{ youtube(id="7aFgeUG9TK4?si=EUEfnGGT4vUa41mJ" start="10:19") }}

I didn't give Slint a shot because it required money [until recently](https://slint.dev/blog/slint-1.1-released). Maybe it deserves another go?

<blockquote class="twitter-tweet" data-theme="dark"><p lang="en" dir="ltr">how weird is it that Slint&#39;s charging for a GUI library in a young language</p>&mdash; Brooke (@goingforbrooke) <a href="https://twitter.com/goingforbrooke/status/1724544156377534884?ref_src=twsrc%5Etfw">November 14, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

# Conclusion

[egui](#egui) has my heart, but I'm eager to try [Dioxus](#honorable-mention-dioxus). [Xilem](#honorable-mention-xilem) might eventually come to save us all, but [egui](#egui), [iced](#iced) and [dioxus](#honorable-mention-dioxus) are the most viable bridges to mouse-land. 🐁

# Additional Material

The list of Rust GUI projects on [areweguiyet.com](https://areweguiyet.com) is regularly updated with new and archived repos. The merits of the most popular options are regularly updated on LogRocket's [blog](https://blog.logrocket.com/state-of-rust-gui-libraries/).

Igor Loskutov's [50 shades of Rust](https://monadical.com/posts/shades-of-rust-gui-library-list.html#18-Makepad) offers code samples and thorough commentary on an incredible breadth of 50 libraries. A code-rich overview can be found in [State of Rust GUIs](https://dev.to/davidedelpapa/rust-gui-introduction-a-k-a-the-state-of-rust-gui-libraries-as-of-january-2021-40gl). The code samples are getting out of date, but they convey the ethos of each library.

The [performance comparision of Tauri, Iced, and egui](http://lukaskalbertodt.github.io/2023/02/03/tauri-iced-egui-performance-comparison.html) offers an intriguing account of each approach's resource cost.

