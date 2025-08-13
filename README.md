# ReqEmbed

[![Hex.pm](https://img.shields.io/hexpm/v/req_embed)](https://hex.pm/packages/req_embed)
[![Hexdocs](https://img.shields.io/badge/hexdocs-latest-blue.svg)](https://hexdocs.pm/req_embed)

<!-- MDOC -->

[Req](https://hex.pm/packages/req) plugin for [oEmbed](https://oembed.com).

## Features

* **Auto-Discovery**: Finds oEmbed endpoints via HTML link tags ([oEmbed discovery](https://oembed.com/#section4))
* **350+ Providers**: YouTube, Twitter, Instagram, and [more](https://github.com/leandrocp/req_embed/blob/main/priv/providers.json)
* **Content Types**: Video, Photo, Rich media, and Link embeds
* **Phoenix Ready**: HEEx component and HTML helpers
* **Customizable**: CSS classes, responsive design, and embed options

## Installation

Add `:req_embed` dependency:

```elixir
def deps do
  [
    {:req_embed, "~> 0.2"}
  ]
end
```

Or use [Igniter](https://hexdocs.pm/igniter):

```sh
mix igniter.install req_embed
```

## Usage

req_embed can be used directly as a Req plugin, or as a Phoenix component to render oEmbed content in HEEx templates.

### Intro

Watch this [ElixirCasts episode](https://elixircasts.io/reqembed) that covers all the features listed below.

<a href="https://elixircasts.io/reqembed">
  <img src="https://raw.githubusercontent.com/leandrocp/req_embed/refs/heads/main/assets/elixir_casts.png" width="512" alt="ElixirCasts Episode 196" />
</a>

### Req Plugin

```elixir
req = Req.new() |> ReqEmbed.attach()

Req.get!(req, url: "https://www.youtube.com/watch?v=XfELJU1mRMg").body
#=>
# %ReqEmbed.Video{
#   type: "video",
#   version: "1.0",
#   title: "Rick Astley - Never Gonna Give You Up (Official Music Video)",
#   author_name: "Supirorguy508",
#   author_url: "https://www.youtube.com/@supirorguy5086",
#   provider_name: "YouTube",
#   provider_url: "https://www.youtube.com/",
#   cache_age: nil,
#   thumbnail_url: "https://i.ytimg.com/vi/XfELJU1mRMg/hqdefault.jpg",
#   thumbnail_width: 480,
#   thumbnail_height: 360,
#   html: "<iframe width=\"200\" height=\"113\" src=\"https://www.youtube.com/embed/XfELJU1mRMg?feature=oembed\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" referrerpolicy=\"strict-origin-when-cross-origin\" allowfullscreen title=\"Rick Astley - Never Gonna Give You Up (Official Music Video)\"></iframe>",
#   width: 200,
#   height: 113
# }
```

When successful, the response body will contain either one of the following structs representing the oEmbed type:

  - `ReqEmbed.Link`
  - `ReqEmbed.Photo`
  - `ReqEmbed.Rich`
  - `ReqEmbed.Video`

### Phoenix Component

Use [ReqEmbed.embed/1](https://hexdocs.pm/req_embed/ReqEmbed.html#embed/1) to display oEmbed content in HEEx templates:

```heex
<ReqEmbed.embed url="https://www.youtube.com/watch?v=XfELJU1mRMg" class="aspect-video" />
```

Renders:

```html
<iframe allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen="allowfullscreen" class="aspect-video" frameborder="0" referrerpolicy="strict-origin-when-cross-origin" src="https://www.youtube.com/embed/XfELJU1mRMg?feature=oembed" title="Rick Astley - Never Gonna Give You Up (Official Music Video)"></iframe>
```

Note that `:phoenix_live_view` is required to use the component, it's not a direct dependency.

### Raw HTML

Or alternatively use [ReqEmbed.html/2](https://hexdocs.pm/req_embed/ReqEmbed.html#html/2) to get the oEmbed content as HTML:

```elixir
ReqEmbed.html("https://www.youtube.com/watch?v=XfELJU1mRMg")
# <iframe width="200" height="113" src="https://www.youtube.com/embed/XfELJU1mRMg?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen title="Rick Astley - Never Gonna Give You Up (Official Music Video)"></iframe>
```

Wrap it in a `{:safe, html}` tuple or call `Phoenix.HTML.raw/1` to render it in Phoenix templates.
