# ReqEmbed - Usage Rules for AI Agents

ReqEmbed is an Elixir library that provides a Req plugin for fetching and embedding oEmbed content from 350+ providers (YouTube, Twitter, Instagram, Flickr, etc.).

## When to Use ReqEmbed

**Use ReqEmbed when:**
- Embedding third-party content (videos, photos, rich media) in Phoenix applications
- Fetching oEmbed data from URLs programmatically
- Working with content from supported providers (YouTube, Twitter, Instagram, etc.)
- Building features that display social media posts, videos, or photos
- You need auto-discovery of oEmbed endpoints from arbitrary URLs

**Don't use ReqEmbed when:**
- You need to embed content from providers that don't support oEmbed
- You're building a custom media player (use ReqEmbed to fetch metadata, then build your own player)
- You need real-time updates from social media (oEmbed provides snapshots, not live data)
- Security is critical and you cannot trust third-party HTML (oEmbed returns raw HTML that should be sanitized)

## Installation

```elixir
def deps do
  [
    {:req_embed, "~> 0.3"}
  ]
end
```

Or using Igniter:

```sh
mix igniter.install req_embed
```

## Core Usage Patterns

### 1. Req Plugin (Most Common)

**DO** attach ReqEmbed to a Req instance and use it to fetch oEmbed data:

```elixir
req = Req.new() |> ReqEmbed.attach()
result = Req.get!(req, url: "https://www.youtube.com/watch?v=XfELJU1mRMg")

# result.body will be one of:
# - %ReqEmbed.Video{}
# - %ReqEmbed.Photo{}
# - %ReqEmbed.Rich{}
# - %ReqEmbed.Link{}
```

**DO** pattern match on the response type to handle different embed types:

```elixir
req = Req.new() |> ReqEmbed.attach()

case Req.get(req, url: url) do
  {:ok, %{body: %ReqEmbed.Video{html: html}}} ->
    # Handle video embed
    html

  {:ok, %{body: %ReqEmbed.Photo{url: photo_url}}} ->
    # Handle photo embed
    photo_url

  {:ok, %{body: %ReqEmbed.Rich{html: html}}} ->
    # Handle rich content (tweets, etc.)
    html

  {:error, reason} ->
    # Handle errors
    Logger.error("Failed to fetch embed: #{inspect(reason)}")
    nil
end
```

### 2. Phoenix Component (For Templates)

**DO** use the Phoenix component in HEEx templates when you need to render embeds:

```heex
<ReqEmbed.embed url="https://www.youtube.com/watch?v=XfELJU1mRMg" />

<!-- With CSS class for responsive design -->
<ReqEmbed.embed
  url="https://www.youtube.com/watch?v=XfELJU1mRMg"
  class="aspect-video w-full"
/>

<!-- Photo with caption -->
<ReqEmbed.embed
  url="https://www.flickr.com/photos/example/123"
  include_caption={true}
/>
```

**Important:** The component requires `:phoenix_live_view` to be installed. It's not a direct dependency.

### 3. HTML Function (For Dynamic HTML)

**DO** use `ReqEmbed.html/2` when you need raw HTML without the component:

```elixir
# Get raw HTML
html = ReqEmbed.html("https://www.youtube.com/watch?v=XfELJU1mRMg")

# In Phoenix templates, wrap in {:safe, html} or use Phoenix.HTML.raw/1
Phoenix.HTML.raw(html)
```

**DO** use the `:class` option for responsive iframes:

```elixir
# The class option removes width/height attributes and adds CSS class
html = ReqEmbed.html(url, class: "aspect-video w-full")
```

## Options and Configuration

### Plugin Options

Pass options to `ReqEmbed.attach/2`:

```elixir
req = Req.new() |> ReqEmbed.attach(
  # Query parameters sent to oEmbed endpoint
  query: %{maxwidth: 800, maxheight: 600},

  # Enable/disable auto-discovery (default: true)
  discover: true
)
```

**DO NOT** try to override `:url` or `:format` query parameters - they are managed by the plugin:

```elixir
# ❌ WRONG: url and format are automatically set
req = Req.new() |> ReqEmbed.attach(
  query: %{url: "...", format: "json"}  # These will be ignored
)

# ✅ CORRECT: Only pass provider-specific parameters
req = Req.new() |> ReqEmbed.attach(
  query: %{maxwidth: 800, maxheight: 600}
)
```

### HTML/Component Options

Available options for `ReqEmbed.html/2` and `<ReqEmbed.embed>`:

- `:class` - CSS class for iframe (removes width/height when set)
- `:include_caption` - Show photo title in `<figcaption>` (default: true)

```elixir
# Responsive video with Tailwind CSS
html = ReqEmbed.html(url, class: "aspect-video w-full rounded-lg")

# Photo without caption
html = ReqEmbed.html(photo_url, include_caption: false)
```

## Response Types

ReqEmbed returns one of four typed structs based on the oEmbed response:

### ReqEmbed.Video

For video embeds (YouTube, Vimeo, etc.):

```elixir
%ReqEmbed.Video{
  type: "video",
  html: "<iframe ...>",  # Required: HTML to embed video player
  width: 640,            # Required: Display width
  height: 360,           # Required: Display height
  title: "Video title",
  author_name: "Author",
  thumbnail_url: "...",
  # ... other common fields
}
```

### ReqEmbed.Photo

For static photos (Flickr, Instagram photos, etc.):

```elixir
%ReqEmbed.Photo{
  type: "photo",
  url: "https://...",    # Required: Image source URL
  width: 1024,           # Required: Image width
  height: 768,           # Required: Image height
  title: "Photo title",
  # ... other common fields
}
```

### ReqEmbed.Rich

For rich HTML content (Tweets, embed cards, etc.):

```elixir
%ReqEmbed.Rich{
  type: "rich",
  html: "<blockquote ...>",  # Required: HTML markup
  width: 550,                # Required: Display width
  height: 400,               # Required: Display height
  # ... other common fields
}
```

### ReqEmbed.Link

Generic fallback for simple embeds:

```elixir
%ReqEmbed.Link{
  type: "link",
  title: "Link title",
  author_name: "Author",
  thumbnail_url: "...",
  # ... other common fields
}
```

## Common Patterns

### Caching Embed Responses

**DO** cache oEmbed responses to avoid repeated API calls:

```elixir
defmodule MyApp.EmbedCache do
  use GenServer

  def fetch_embed(url) do
    case get_from_cache(url) do
      {:ok, embed} ->
        embed

      :miss ->
        req = Req.new() |> ReqEmbed.attach()
        case Req.get(req, url: url) do
          {:ok, %{body: embed}} ->
            put_in_cache(url, embed)
            embed
          error ->
            error
        end
    end
  end
end
```

**Important:** Respect the `cache_age` field in responses:

```elixir
case Req.get(req, url: url) do
  {:ok, %{body: %{cache_age: cache_age} = embed}} ->
    ttl = cache_age || :timer.hours(24)  # Default to 24 hours if not specified
    MyCache.put(url, embed, ttl: ttl)
end
```

### Handling Failures Gracefully

**DO** provide fallbacks for failed embeds:

```elixir
def render_embed(url) do
  req = Req.new() |> ReqEmbed.attach()

  case Req.get(req, url: url) do
    {:ok, %{body: embed}} ->
      # Successfully fetched
      embed

    {:error, _reason} ->
      # Fallback to a simple link
      %ReqEmbed.Link{
        type: "link",
        title: url,
        author_url: url
      }
  end
end
```

### Auto-Discovery vs Known Providers

**DO** use auto-discovery (default behavior) when working with arbitrary URLs:

```elixir
# Auto-discovery enabled (default) - works with any oEmbed-compatible URL
req = Req.new() |> ReqEmbed.attach()
Req.get!(req, url: "https://example.com/some-page")
```

**DO** disable auto-discovery if you only work with known providers (faster):

```elixir
# Skip HTML parsing, only use known provider endpoints
req = Req.new() |> ReqEmbed.attach(discover: false)
Req.get!(req, url: "https://www.youtube.com/watch?v=...")
```

### Working with Phoenix

**DO** render embeds safely in Phoenix templates:

```heex
<!-- Using the component (recommended) -->
<ReqEmbed.embed url={@video_url} class="aspect-video" />

<!-- Using html/2 function -->
<%= Phoenix.HTML.raw(ReqEmbed.html(@video_url)) %>
```

**DO** handle embeds in LiveView:

```elixir
defmodule MyAppWeb.PostLive do
  use MyAppWeb, :live_view

  def mount(%{"url" => url}, _session, socket) do
    # Fetch in mount or handle_info to avoid blocking
    send(self(), {:fetch_embed, url})
    {:ok, assign(socket, embed: nil, loading: true)}
  end

  def handle_info({:fetch_embed, url}, socket) do
    req = Req.new() |> ReqEmbed.attach()

    embed =
      case Req.get(req, url: url) do
        {:ok, %{body: embed}} -> embed
        _ -> nil
      end

    {:noreply, assign(socket, embed: embed, loading: false)}
  end
end
```

### Responsive Design

**DO** use CSS classes for responsive embeds instead of fixed dimensions:

```heex
<!-- ✅ CORRECT: Responsive with Tailwind -->
<ReqEmbed.embed url={@url} class="aspect-video w-full max-w-4xl mx-auto" />

<!-- ❌ WRONG: Fixed dimensions from oEmbed response -->
<ReqEmbed.embed url={@url} />
<!-- This uses width/height from API, which may not be responsive -->
```

## Security Considerations

**IMPORTANT:** oEmbed responses contain raw HTML from third-party providers.

**DO** be aware that embedded HTML is not sanitized:

- Video/Rich types include `html` field with raw iframe/HTML content
- This HTML comes directly from the provider
- Trusted providers (YouTube, Twitter, etc.) are generally safe
- Consider using Content Security Policy (CSP) headers

**DO** validate URLs before fetching embeds:

```elixir
def safe_embed(url) do
  uri = URI.parse(url)

  # Only allow HTTPS
  if uri.scheme == "https" do
    req = Req.new() |> ReqEmbed.attach()
    Req.get(req, url: url)
  else
    {:error, :insecure_url}
  end
end
```

## Testing

**DO** mock oEmbed responses in tests:

```elixir
test "handles video embeds" do
  # Mock the HTTP request
  mock_response = %ReqEmbed.Video{
    type: "video",
    html: "<iframe src='...'></iframe>",
    width: 640,
    height: 360
  }

  # Test your code
  assert %ReqEmbed.Video{} = fetch_embed(url)
end
```

## Common Mistakes

**DON'T** assume all embeds have the same structure:

```elixir
# ❌ WRONG: Not all types have html field
def get_embed_html(url) do
  req = Req.new() |> ReqEmbed.attach()
  %{body: %{html: html}} = Req.get!(req, url: url)
  html  # Will crash for Photo/Link types
end

# ✅ CORRECT: Pattern match on type
def get_embed_html(url) do
  req = Req.new() |> ReqEmbed.attach()

  case Req.get!(req, url: url) do
    %{body: %ReqEmbed.Video{html: html}} -> html
    %{body: %ReqEmbed.Rich{html: html}} -> html
    %{body: %ReqEmbed.Photo{}} -> nil  # Photos don't have html
    %{body: %ReqEmbed.Link{}} -> nil   # Links don't have html
  end
end
```

**DON'T** ignore error cases:

```elixir
# ❌ WRONG: Will crash on 404, network errors, etc.
embed = Req.get!(req, url: user_provided_url).body

# ✅ CORRECT: Handle errors explicitly
case Req.get(req, url: user_provided_url) do
  {:ok, %{body: embed}} -> embed
  {:error, reason} -> handle_error(reason)
end
```

**DON'T** fetch embeds synchronously in web requests:

```elixir
# ❌ WRONG: Blocks the request while fetching from third-party API
def show(conn, %{"url" => url}) do
  req = Req.new() |> ReqEmbed.attach()
  embed = Req.get!(req, url: url).body  # May take seconds!
  render(conn, "show.html", embed: embed)
end

# ✅ CORRECT: Fetch async or use background job
def show(conn, %{"url" => url}) do
  Task.start(fn ->
    req = Req.new() |> ReqEmbed.attach()
    embed = Req.get!(req, url: url).body
    broadcast_embed(conn.assigns.user_id, embed)
  end)

  render(conn, "show.html", loading: true)
end
```

## Performance Tips

1. **Cache aggressively** - oEmbed responses rarely change, respect `cache_age`
2. **Disable discovery** when working only with known providers
3. **Set appropriate timeouts** on the Req client for third-party APIs
4. **Fetch asynchronously** in LiveView/web contexts
5. **Use background jobs** for batch embedding operations

## Reference

- oEmbed Spec: https://oembed.com/
- Supported providers: 350+ including YouTube, Twitter, Instagram, Flickr, Vimeo, SoundCloud, etc.
- Provider list: https://github.com/leandrocp/req_embed/blob/main/priv/providers.json
- ElixirCasts episode: https://elixircasts.io/reqembed
