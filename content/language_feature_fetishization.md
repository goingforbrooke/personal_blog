+++
title = "Language Feature Fetishization"
date = 2025-02-28 

[taxonomies]
tags = ["new_tag"]
+++

A fetish for language features plagues many Rust engineers. It’s a hot new language that’s brings a number of exciting new mechanisms to my fingertips, but I’m careful about implementing them prematurely.

<!-- more -->

# The Problem

{{ image(src="golden_crab_idol.jpeg",
         alt="MISSING_ALT_TEXT",
         style="border-radius: 8px;") }}

Advanced language features are supposed to make coding easier, but they can be a hindrance if used incorrectly. They're just so _cool_ 😎 and new ✨ that it's hard to resist them.

Intermediate and advanced engineers seek to distinguish themselves from beginners by showcasing their proficiency in implementing these features. As if comprehensive knowledge of [The Book](https://doc.rust-lang.org/book/) is more important than making something that _just works_.

# Example: `for_each`

A well-placed [`for_each`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.for_each) is pleasing to the eye and easy to reason about.

Beginning with a simple [`for`](https://doc.rust-lang.org/std/keyword.for.html) loop, the nesting and `let` looks pretty gross...

```rust
let five_numbers = vec![1, 2, 3, 4, 5];

for this_number in &five_numbers {
    let doubled_number = this_number * 2;
    println!("Original: {}, Doubled: {}", this_number, doubled_number);
}
```

... Since we're _cool kids_, we convert it to a `for_each`...

```rust
let five_numbers = vec![1, 2, 3, 4, 5];

five_numbers.iter().for_each(|&this_number| {
    let doubled_number = this_number * 2;
    println!("Original: {}, Doubled: {}", this_number, doubled_number);
});
```

... and end up with exactly what we had before, but it looks _cooler_ and, we expect, will be more ergonomic in later implementations.

A few iterations later, we're dealing with files and we've added some initial error handling. We use [`anyhow`](https://crates.io/crates/anyhow) for catch-alls that evolve into explict [`thiserror`](https://crates.io/crates/thiserror) [enum](https://doc.rust-lang.org/book/ch06-01-defining-an-enum.html)s over time. We want Rust's explict error handling because it has the practical effect of keeping our app from crashing on users. There's no imagined problem here-- catching errors, even handling of them isn't built out yet, has immediate payoffs with logging and observability.

```rust
#[derive(Error, Debug)]
enum FileWriteError {
    #[error("failed to create file: {0}")]
    CreateFileError(#[from] io::Error),

    #[error("failed to write to file: {0}")]
    WriteError(#[from] io::Error),
}

let five_numbers = vec![1, 2, 3, 4, 5];

let mut file_handle = File::create(file_path).context("Could not create output file")?;

five_numbers.iter().try_for_each(|&this_number| {
    writeln!(file_handle, "Original: {}, Doubled: {}", this_number, this_number * 2)
    .map_err(FileWriteError::from)
    .context("Failed to write to file")
})?;
```

Our [`for_each`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.for_each) has become a [`try_for_each`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.try_for_each) so it'll play nice with [`anyhow`](https://docs.rs/anyhow/latest/anyhow/)'s [`context`](https://docs.rs/anyhow/latest/anyhow/trait.Context.html). It's clever and compact, but our function's nowhere near accomplishing something useful. Meanwhile, the cognitive load has probably distracted us from implementing stuff core business logic/stuff that's actually useful.

> We could get into nitty-gritty of much-loved alternatives like [`map`](https://doc.rust-lang.org/std/iter/struct.Map.html), [`ok_or_else`](https://doc.rust-lang.org/std/option/enum.Option.html#method.ok_or_else) and [`iter_mut`](https://doc.rust-lang.org/std/slice/struct.IterMut.html), but that would miss the point of this example.

Beyond simple examples and well-wrought "end product" code, these frills are best left for later stages in the development pipeline when baseline functionality's been established.

> As an avid Vim (bindings) user, I find that compact code is inimical to line selections (Shift + v) that make high-level reorganization a breeze.

Instead, I stick to [`for`](https://doc.rust-lang.org/std/keyword.for.html)s and the almighty [`match`](https://doc.rust-lang.org/reference/expressions/match-expr.html) for as long as I can. In practice, the same code looks like this:

```rust
#[derive(Error, Debug)]
enum FileWriteError {
    #[error("failed to create file: {0}")]
    CreateFileError(#[from] io::Error),

    #[error("failed to write to file: {0}")]
    WriteError(#[from] io::Error),
}

let five_numbers = vec![1, 2, 3, 4, 5];

let mut file_handle = match File::create("output.txt") {
    Ok(file_handle) => file_handle,
    Err(e) => return Err(FileWriteError::CreateFileError(e)).context("Could not create output file"),
};

for this_number in five_numbers {
    match writeln!(file_handle, "Original: {}, Doubled: {}", this_number, this_number * 2) {
        Ok(_) => (),
        Err(e) => return Err(FileWriteError::WriteError(e)).context("Failed to write to file"),
    }
}
```

This is much easier to skim and hack on. The deeper nesting's easy to forgive because each visually-aligned level implies a separation of concerns. Skimming the first of these levels, this is what goes through my head:

```rust
enum FileWriteError {
```

> 💭 hmmm, error stuff. Cool-- glad it's there. I'll stare at it later if this change busts something

```rust
let five_numbers = vec![1, 2, 3, 4, 5];
```

> 💭 guess we'll be doing something with these numbers

```rust
let mut file_handle = match File::create("output.txt") {
```

> 💭 making a file? Nice. Don't know why, (yet), but I appreciate that the name's right here

```rust
for this_number in five_numbers {
```

> 💭 here's where those numbers come in!

```rust
match writeln!(file_handle, "Original: {}, Doubled: {}", this_number, this_number * 2) {
```

> 💭 we double them and write to the file. Cool.

This understanding makes it easy to implement changes without needing to [grok](https://en.wikipedia.org/wiki/Grok) long method chains like `writeln!(...).map_err(...).context(...)`, which are often crammed together on one line. What's more, our subdivision of code blocks makes it easy to move operations to other functions and/or modules.

# Example: Trait Overuse

[Traits](https://doc.rust-lang.org/book/ch10-02-traits.html) are _cool_, but they're too often used to build abstractions in "the long shadow of [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming)." Abstractions are supposed to make our jobs easier, but they can cost more than their ergonomic reward.

For example, if we're building a RESTful API with [`warp`](https://crates.io/crates/warp), we might think it best to define some default behaviors for every route with a [trait](https://doc.rust-lang.org/book/ch10-02-traits.html).

```rust
#[derive(Debug, Serialize, Deserialize)]
struct ApiResponse {
    message: String,
}

#[async_trait]
trait BaseRoute: Send + Sync + 'static {
    async fn handle_request(&self) -> warp::reply::Json;
}

struct DefaultRoute;

#[async_trait]
impl BaseRoute for DefaultRoute {
    async fn handle_request(&self) -> warp::reply::Json {
        let response = ApiResponse {
            message: "Default Route Response".to_string(),
        };
        warp::reply::json(&response)
    }
}

fn base_route<R: BaseRoute>(request_handler: R) -> impl warp::Filter<Extract=(warp::reply::Json, ), Error=warp::Rejection> + Clone {
    warp::path!("base")
        .and(warp::get())
        .and_then(move || {
            let handler = request_handler.handle_request();
            async move { Ok::<_, warp::Rejection>(handler.await) }
        })
}
```

Without the [`trait`](https://doc.rust-lang.org/book/ch10-02-traits.html), we'd have to add the base response to each route, which isn't very [dry](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). Even so, I put off using [`traits`](https://doc.rust-lang.org/book/ch10-02-traits.html) until my routes have reached a critical mass (say 15 or so). There's no great cost to having the same line of code at the end of each route definition because it's consistent and easy to dry up later. Emphasis on the _later_ here because, more often than not, traits are used too early in the development cycle where they sow confusion by prematurely increasing complexity. 

> There are plenty of caveats here, but we're going generalizations.

```rust
let response = ApiResponse {
        message: "Default Route Response".to_string(),
};
```

# The Compiler is Smarter than I am

> What about performance?

We’re willing to sacrifice developer time for the illusion of elegance and efficiency, perhaps because computer science programs filter for the types of mind that love to obsess over for loop structures and sorting algorithms. They're fun. Simple. Contained. Measurable. It's only natural that when I, the engineer, come across a use case that _could_ require these things, I'm inclined to use them. Moreover, it saves me from undertaking more nebulous but important tasks like error handling, logging, and user feedback that probably rank higher in the bigger picture.

# Why We Fall into these Traps

Why do I fall into these traps? Because it inflates my ego, of course. It feels good to think of myself as an intelligent, competent engineer, as well as to be thought of as such by my peers. Sharing this blog post is frightening. And code? Terrifying. It's feels safer to write code that's optimized for my benefit more than the user or even my teammates.

# My Alternative

I'm an [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming) pessimist, yet not a [functional](https://en.wikipedia.org/wiki/Functional_programming) zealot, who values good judgment over dogma. That reduces to platitudes like "B wise" or "it depends," so I follow two rules of thumb.

# Rule of Thumb #1: Leave it for the Crates

I've found success in the assumption that sufficiently advanced language features should be left to for those creating crates for general consumption. This doesn't mean the internal API exposed by a project's `lib.rs` file, but a project aimed purely at abstracting away functionality for applications. In those contexts, [`trait`](https://doc.rust-lang.org/book/ch10-02-traits.html)s provide valuable hints on [impl](https://doc.rust-lang.org/std/keyword.impl.html)ementing complex code interfaces. In an early project, they can detract from core logic.

> For those hailing from Python or languages, by "crate," I mean "package" or "library."


# Rule of Thumb #2: Profile it First

It's easy to forget that [the compiler is smarter than I am](#the-compiler-is-smarter-than-i-am) and try to do its job for it. I've spent countless hours happily tinkering with lifetimes and iterators only to find that my efforts didn't change performance one bit. Rather, my efforts to prevent bottlenecks makes it harder to identify and fix them later.

Forcing myself to profile before I optimize saves time and forces me to drop a [smoke test](https://en.wikipedia.org/wiki/Smoke_testing_(software)) here and there, a practice with its own benefits.
