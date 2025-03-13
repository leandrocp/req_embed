# ReqEmbed

<!-- MDOC -->

[oEmbed](https://oembed.com) plugin for [Req](https://hex.pm/packages/req).

Supports [discovery](https://oembed.com/#section4) and 300+ [providers](https://github.com/BeaconCMS/req_embed/blob/main/priv/providers.json).

## Usage

```elixir
Mix.install([
  {:req, "~> 0.5"},
  {:req_embed, "~> 0.1"}
])

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
