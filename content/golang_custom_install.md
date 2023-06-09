+++
title = "Go: Get Off My Lawn"
date = 2023-06-08

[taxonomies]
tags = ["golang", "toolchain", "howto"]
+++

So, this gopher came to my `~`, s*** on my lawn, and built a fence around it, as if it was theirs. There's gotta be a better way to bring home a (Go)pher.

<!-- more -->

# Travesty

{{ image(src="golang_lawn.png",
         alt="The Golang mascot sitting on the lawn in front of a house",
         style="border-radius: 8px;") }}

Installing Go unceremoniously creates `~/go`. Worse, it takes `sudo` to `rm -rf` the directory due to permission issues. Thankfully, it doesn't pollute `~/.zshrc`/`~/.bashrc` with PATH additions, but that leaves Go's binaries (`~/go/bin`) out in the cold.

# Solution

> The GOPATH environment variable specifies the location of your workspace. It defaults to a directory named go inside your home directory, so $HOME/go on Unix, $home/go on Plan 9, and %USERPROFILE%\go (usually C:\Users\YourName\go) on Windows.

I use `~/.go` instead of `~/go` by setting the [`$GOPATH` environment variable](https://go.dev/doc/gopath_code#the-gopath-environment-variable) to `$HOME/go` before installation.

`~/.zshrc`

```zsh
# Use `~/.go` instead of `~/go` for Golang.
export GOPATH="$HOME/.go"
```

Then I add `~/.go/bin` to my `PATH` so I can use `go install`ed binaries like [`lipo`](https://github.com/konoui/lipo).

`~/.zshrc`

```zsh
# Add Go binaries to the path.
export PATH=$PATH:~/.go/bin
```

With those additions, reload `.zshrc` for the changes to take effect.

```zsh
$ source ~/.zshrc
```

# Install Go 

Go's [installation docs](https://go.dev/doc/install) recommend downloading a package file, but I use [a brew formula](https://formulae.brew.sh/formula/go) so things stay up-to-date.

# Bonus: Avoid Name Collisions

Installing the [Go version of `lipo`](https://github.com/konoui/lipo) collides with [MacOS's `lipo`](https://developer.apple.com/documentation/apple-silicon/building-a-universal-macos-binary#Determine-Whether-Your-Binary-Is-Universal).

```zsh
$ go install github.com/konoui/lipo@latest` 
$ where lipo
/usr/bin/lipo
/Users/goingforbrooke/.go/bin/lipo
```

This means that `lipo` will only call MacOS's `lipo` (`/usr/bin/lipo`). The Go version of `lipo`'s still accessible with its full path (`/Users/goingforbrooke/.go/bin/lipo`), but that's irritating to type.

To avoid calling the wrong `lipo`, create a [softlink](https://en.wikipedia.org/wiki/Symbolic_link) in a directory on `PATH`, such as `~/bin/`.

```zsh
$ ln -s ~/.go/bin/lipo ~/bin/golipo
```

That made a softlink called `golipo` in `~/bin`, as `ls -l` can show us.

```zsh
$ ls -l bin/golipo
lrwxr-xr-x 24 goingforbrooke  4 Feb 42:42 bin/golipo -> /Users/flow/.go/bin/lipo
```

Again, `source ~/.zshrc` for the changes to take effect.

Now the Go version of `lipo` is accessible via `golipo`.

```zsh
$ where golipo
/Users/goingforbrooke/bin/golipo
```
