+++
title = "POST_TITLE"
date = DATE_TODAY 

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

# YouTube Embeddings

Use my shortcode. Timestamps are automatically converted to seconds and added to the URL.

`{{ youtube(id="gcBJ7cPSALo?si=JSF3XnMv-1EdbxYg" start="13:01") }}`

{{ youtube(id="gcBJ7cPSALo?si=JSF3XnMv-1EdbxYg" start="13:01") }}

- use the link provided by the "➡️Share" button on YouTube
    - this has the `?si=...` parameter in it, which is necessary to make timestamps work
