+++
title = "My GUIs Suck and that's Okay"
date = 2023-06-13 

[taxonomies]
tags = ["GUI"]
+++

I'll be the first to admit that my UIs don't look great and the second to admit it's okay. There's an undue expectation that the simplest application has to have a snazzy frontend (probably written in ReactJS) or it's not legitimate software. My resume's littered with pandering to this sentiment-- so much development time lost to visualizing stakeholder value so my manager had a dashboard to know what we were up to 🤢.

<!-- more -->

# I Don't Hate GUIs

{{ image(src="crt_gui.png",
         alt="Old CRT monitor with a basic blue GUI.",
         style="border-radius: 8px;") }}

That isn't to say that I don't get why people enjoy it-- it seems incredibly fun to think through a user's experience and design something that not only gives them superpowers, but is a pleasure to use. Beyond basic implementations, there's this aesthetic dimension where skilled UI designers think through fonts, styling, positioning, spacing, and color pallets with an artistic mindset. And that's really really cool.

> I fully respect GUI design as an incredible speciality apart from my own.

# Tyranny of the Wireframe

What I take issue with is the default expectation that if your application has a GUI, then it has to look incredible. This creates chasms between libraries, CLIs and GUIs with little sympathy for what lies inbetween. Instead of creating something in one of these chasms-- a CLI that only runs one command or a GUI that looks like it's from the 90s, we live in a world of REST-flavored state issues where users are frustrated by software that makes them feel incompetent.

# Settling for Mediocrity

When a website doesn't load correctly or a button doesn't work, subtle delays in response time signal to my developer brain that something's wrong long before it fails. Meanwhile, non-developers are mired in a world of broken “submit” buttons and old data that conspire to convince them that they're “just not good at technology.” This separates users from the functionality that they crave, damaging trust. 

> So, why don't we settle for something less flashy and more functional?

Great swaths of developers eschew GUIs entirely, embracing the perspective that they'll never ship to a non-technical user. That's a legit stance to take, but it would be nice to have another option.

# Lost Development Time

How many developer hours are lost to making dashboards and tuning elements that don't need to exist? In the case of the ubiquitous webapp, two interfaces are required— a well-documented RESTful API in addition to the frontend. Changes to one must reflect changes in the other, exponentially raising the time-cost of development.

# Visual Apologetics

Before showing my rough-hewn GUIs to non-technical folks, I mentally brace myself for the “oh, that's nice” moment when Zoomers think that I'm unskilled and anyone older gets XP flashbacks. The experience sucks so bad that I'd be mortally afraid to pitch it to investors.

> It comes down to ego.

I'm scared to make something that doesn't look like Facebook because I'm afraid that it'll make me look bad. Meta has teams of engineers and designers dedicated to its UI, but I feel held to the same standard on personal projects.

# Humble GUIs

If the project has the money and people for creating and maintaining beautiful UX, then I go for it. Otherwise, I dispense with the frills and focus on making something responsive that just works and builds user trust. That re-focuses my work on what I'm good at— making great internals. 

> I don't make crappy GUIs. I make humble GUIs.

With good code modularity and documentation, I can count on it being easy to add GUI when I need it, or, even better, tapping someone else to do it for me.

