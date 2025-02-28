+++
title = "Language Feature Fetishization"
date = 2025-02-28 

[taxonomies]
tags = ["new_tag"]
+++

A funny, yet interesting intro paragraph.

<!-- more -->

# FIRST_HEADING

{{ image(src="golang_lawn.png",
         alt="MISSING_ALT_TEXT",
         style="border-radius: 8px;") }}

Another paragraph.

# Twitter Embeddings

[How to embed a Post on your website or blog](https://help.twitter.com/en/using-x/how-to-embed-a-post)

<blockquote class="twitter-tweet" data-dnt="true" data-theme="dark"><p lang="en" dir="ltr">4 years ago today, Denjell &amp; Lucas, the cofounders of Tauri, wrote C++ for the last time and decided that <a href="https://twitter.com/rustlang?ref_src=twsrc%5Etfw">@rustlang</a> would be the foundation for what today is the most popular of all <a href="https://twitter.com/hashtag/OSS?src=hash&amp;ref_src=twsrc%5Etfw">#OSS</a> projects of its age on <a href="https://twitter.com/github?ref_src=twsrc%5Etfw">@github</a> written in Rust:<a href="https://t.co/ZhrGKOJHAd">https://t.co/ZhrGKOJHAd</a> <a href="https://t.co/VsyMRwRXmu">pic.twitter.com/VsyMRwRXmu</a></p>&mdash; Tauri (@TauriApps) <a href="https://twitter.com/TauriApps/status/1660938334884036608?ref_src=twsrc%5Etfw">May 23, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

25-2-28 Blog Post: Language Feature Fetishization

# Thesis

A fetish for language features plagues many Rust engineers. It’s a hot new language that’s brings a number of exciting new mechanisms to my fingertips, but I’m careful in choosing which ones I use.



Problem is that they conflict the code and make it more difficult to work with otherwise. Intermediate in advanced developers, trying to separate themselves from the beginners by showing their feature proficiency and interviews and samples. And while using things like OK or else" in the final iterations of a product or will good for readability and maintainability, under rapid development, even with other people, it's better to keep it simple and open.

# Example 1: Ok or Else

For example, using map functions visually cleaner, but the compiler will abstract away many of those efficiencies anyway.

We're still stuck in this mindset of trying to optimize things for the computer and do the compilers job at the development and it's been committed.

Alternative: matches or if/elses

needs an example of auto compiler optimization

# Example 2: Trait Overuse

Another place where I see this is with trait, but fetishization, or as I like to call it, "the long shadow of OOP". We're taught by the "expert" to build in abstractions and make it easier to work with our code, and object programming brought this to us in the form of class hierarchies and increasing levels of abstraction in python and Java.

# Example 3: Over-Complicated One Liners

Every `let` registers a small warning in my brain that I’ve just allocated memory for something, so code like this…

```rust
example with lots of stuff chained on one line
```

… feels more comfortable than code like this

```rust
same example broken up into multiple lines with different vars
```

The compiler will optimize away these allocations.

# The Compiler is Smarter than I

We’re willing to sacrifice developer time for the illusion of elegance and efficiency, perhaps because computer science programs filter for the types of mind that love to obsess over for loop structures and sorting out algorithms. Naturally, when I, the developer, come across a piece of food requiring these things, I'm inclined to think that it is my job to optimize it as I've been taught most efficient. Moreover, it saves me from more difficult but useful tasks like air handling, logging, and user feedback, that contribute to the big picture.

# Why We Fall into these Traps

Why do I still sometimes fall into these traps? Because it inflates my ego, of course. It feels good to think of myself as an intelligent, competent engineer, as well as to be thought of as such by my peers. Sharing my work with others, even this blog post, is frightening. My code itself is such an intimate representation my inner perspective that I'm afraid to make a PR with anything, but the best of what I could create for it. So, it is easier, safer, and feels better to create code that is optimized for my benefit more than the user, more than my fellow developers. More than myself, in the long run.

# My Alternative

Personally, I'm a bit of a pessimist on loop as a hole and have found in a functional style. Not to say that I am a functional purist, that too has its own pitfall rather than champion the cause of OOP or a functional style, I'm positive that rather in good judgment should be used by the developer to implement the correct features when they are necessary. That's a tall order, though. The equivalent of telling someone "B wise" when they face with difficult decisions.

# Rule of Thumb

How this works out, in Python as well, we can safely assume, is that advanced language feature should be reserved for those creating libraries. My libraries, I don't mean the Lib.RS file inside of a project that is consumed by the binary main at RS file, that crate that is decent for general use and general consumption. For these implementations, treats provide valuable hints about how to implement much more complex code interfaces. Implementing these two heavily within a project, meanwhile, tracks from the overall simplicity of the program, makes react, more difficult, and distracts from the core logic that the users are looking for.