# ReqEmbed

[oEmbed](https://oembed.com) plugin for [Req](https://hex.pm/packages/req).

## Usage

```elixir
Mix.install([
  {:req, "~> 0.5"},
  {:req_embed, "~> 0.1"}
])

req = Req.new() |> ReqEmbed.attach()

Req.get!(req, url: "https://www.youtube.com/watch?v=XfELJU1mRMg").body
#=>
# TODO
```
