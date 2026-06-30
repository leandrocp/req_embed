# Content Security Policy

The oEmbed spec does not define Content Security Policy rules. It only describes how to fetch embed data for a URL. Providers may return HTML, usually an `iframe`, that your app can render.

## Why ReqEmbed does not set CSP

`ReqEmbed` can't safely guess which hosts are used by the HTML returned by providers, so CSP is the app's responsibility. Define it based on the providers your app supports.

## What to do

The oEmbed spec recommends displaying the HTML in an `iframe`, preferably hosted from another domain. See [3. Security considerations](https://oembed.com/#section3) in the oEmbed spec.

Then define the `frame-src` policy in your CSP header. For example:

### Phoenix example

This example allows YouTube and Spotify frames. Adjust it for your app.

```elixir
plug :put_secure_browser_headers, %{
  "content-security-policy" =>
    "frame-src 'self' https://www.youtube.com https://open.spotify.com; " # ...
}
```
