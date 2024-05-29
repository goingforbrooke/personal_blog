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

## Add Exo 2 Font

1. Download from [`freefontsfamily.net`](https://freefontsfamily.net/exo-2-font-family-free/).

2. Reduce included fonts:

```console
Exo2-Black.ttf
Exo2-BlackItalic.ttf
Exo2-Bold.ttf
Exo2-BoldItalic.ttf
Exo2-ExtraBold.ttf
Exo2-ExtraBoldItalic.ttf
Exo2-ExtraLight.ttf
Exo2-ExtraLightItalic.ttf
Exo2-Italic.ttf
Exo2-Light.ttf
Exo2-LightItalic.ttf
Exo2-Medium.ttf
Exo2-MediumItalic.ttf
Exo2-Regular.ttf
Exo2-SemiBold.ttf
Exo2-SemiBoldItalic.ttf
Exo2-Thin.ttf
Exo2-ThinItalic.ttf
OFL.txt
```

```console
Exo2-Bold.ttf
Exo2-BoldItalic.ttf
Exo2-Italic.ttf
Exo2-Regular.ttf
```

3. Convert `.ttf` font files to `.woff` and `.woff2`.

`.woff:`: `ttf2woff Exo2-Regular.ttf Exo2-Regular.woff`
`.woff2`: `woff2_compress Exo2-Regular.ttf`

```
Exo2-Bold.ttf
Exo2-Bold.woff
Exo2-Bold.woff2
Exo2-BoldItalic.ttf
Exo2-BoldItalic.woff
Exo2-BoldItalic.woff2
Exo2-Italic.ttf
Exo2-Italic.woff
Exo2-Italic.woff2
Exo2-Regular.ttf
Exo2-Regular.woff
Exo2-Regular.woff2
```

4. Copy `font-hack.scss`.

```console
cp sass/font-hack.scss sass/font-exo2.scss
```

5. In `font-exo2.scss`, rename instances of `hack` to `exo2` and `Hack` to `Exo2`.

6. In `head.html`, add a configuration option for an additional font.

from:

```tera
{%- if config.extra.use_full_hack_font %}
<link rel="stylesheet" href="{{ get_url(path="font-hack.css", trailing_slash=false) | safe }}">
{% else %}
<link rel="stylesheet" href="{{ get_url(path="font-hack-subset.css", trailing_slash=false) | safe }}">
{% endif -%}
```

to:

```tera
{%- if config.extra.use_full_hack_font == "exo2" %}
<link rel="stylesheet" href="{{ get_url(path="font-exo2.css", trailing_slash=false) | safe }}">
<link rel="stylesheet" href="{{ get_url(path="font-hack.css", trailing_slash=false) | safe }}">
{%- elif config.extra.use_full_hack_font %}
<link rel="stylesheet" href="{{ get_url(path="font-hack.css", trailing_slash=false) | safe }}">
{% else %}
<link rel="stylesheet" href="{{ get_url(path="font-hack-subset.css", trailing_slash=false) | safe }}">
{% endif -%}
```

7. In the blog's `config.toml` (*not* Terminimal's (template) `config.toml`), change config value.

from:

```text
change use_full_hack_font = false
```

to:

```text
change use_full_hack_font = 'exo2'
```

## Check Favicon Status

https://realfavicongenerator.net/favicon_checker?protocol=http&site=www.goingforbrooke.com