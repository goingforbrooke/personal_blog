# Personal Blog of goingforbrooke

Blog with a simple [terminimal theme](https://github.com/pawroman/zola-theme-terminimal).

## Installation

[Install Zola](https://www.getzola.org/documentation/getting-started/installation/)

```console
$ brew install zola
```

Clone the repo.

```console
$ git clone git@github.com:goingforbrooke/personal_blog.git
```

Install the theme.

```console
$ git submodule update --init
```

## Posting

Add new posts.

```console
$ add `.md` files to `content/`
```

Preview the site locally.

```console
$ zola serve
```

Caution: Failing to zero pad post dates will cause build failures. For example, use `date = 2023-05-10`, not `date = 2023-5-10`.
