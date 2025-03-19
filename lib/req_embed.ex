defmodule ReqEmbed do
  @external_resource "README.md"

  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC -->")
             |> Enum.fetch!(1)

  @doc """
  Attach the oEmbed plugin into Req.

  ## Options

    * `:query` (`t:map/0`) - Defaults to `%{}`. The query parameters to be sent to the oEmbed endpoint,
      like `:maxwidth`, `:maxheight`, and others supported by the provider.
      The parameters `:url` and `:format` are managed by the plugin, you can't override them.
      See section [2.2 Consumer Request](https://oembed.com/#section2) for more info.

    * `:discover` (`t:boolean/0`) - Defaults to `true`. When enabled, it will first attempt to auto-discover
      the oEmbed endpoint by looking for the link tag in the HTML response. If no link tag is found, it will
      fallback to searching for a known provider endpoint. When disabled, it will skip the HTML parsing step
      and only use the known provider endpoints.

  ## Examples

      iex> req = Req.new() |> ReqEmbed.attach()
      iex> Req.get!(req, url: "https://x.com/ThinkingElixir/status/1848702455313318251").body
      iex> %ReqEmbed.Rich{
             type: "rich",
             version: "1.0",
             author_name: "ThinkingElixir",
             author_url: "https://twitter.com/ThinkingElixir",
             html: "<blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">News includes upcoming Elixir v1.18 ...
             ...
           }

  """
  @spec attach(Req.Request.t(), keyword()) :: Req.Request.t()
  def attach(%Req.Request{} = request, options \\ []) do
    query = Map.drop(options[:query] || %{}, [:url, :format])

    request
    |> Req.Request.register_options([:oembed_query, :oembed_discover])
    |> Req.Request.merge_options(oembed_query: query, oembed_discover: options[:discover] || true)
    |> Req.Request.prepend_request_steps(oembed_url: &oembed_url/1)
    |> Req.Request.append_response_steps(oembed_decode: &decode/1)
  end

  defp oembed_url(request) do
    case find_endpoint(request) do
      %URI{} = uri ->
        query =
          (uri.query || "")
          |> URI.decode_query()
          |> Map.put("format", "json")
          |> Map.put_new("url", to_string(request.url))
          |> Map.merge(Req.Request.get_option(request, :oembed_query))
          |> URI.encode_query()

        %{request | url: URI.append_query(uri, query)}

      _ ->
        request
    end
  end

  defp find_endpoint(request) do
    url = to_string(request.url)

    case Req.Request.get_option(request, :oembed_discover) && discover_link(url) do
      %URI{} = uri -> uri
      _ -> discover_provider(url)
    end
  end

  @doc false
  def discover_link(url) when is_binary(url) do
    with {:ok, %{body: body}} <- Req.get(url),
         {:ok, doc} <- Floki.parse_document(body),
         [href] <- Floki.attribute(doc, ~s|link[type="application/json+oembed"]|, "href"),
         {:ok, uri} <- URI.new(href) do
      uri
    else
      _ -> nil
    end
  end

  @doc false
  def discover_provider(url) when is_binary(url) do
    case ReqEmbed.Providers.get_by_url(url) do
      %{endpoints: [%{url: url} | _]} -> url
      _ -> nil
    end
  end

  defp decode({request, %{status: 200} = response}) do
    if request.options[:raw] == true or request.options[:decode_body] == false do
      {request, response}
    else
      {request, update_in(response.body, &decode_oembed_response/1)}
    end
  end

  defp decode({request, response}) do
    {request, response}
  end

  defp decode_oembed_response(%{"type" => "photo"} = body) do
    %ReqEmbed.Photo{
      type: body["type"],
      version: body["version"],
      title: body["title"],
      author_name: body["author_name"],
      author_url: body["author_url"],
      provider_name: body["provider_name"],
      provider_url: body["provider_url"],
      cache_age: body["cache_age"],
      thumbnail_url: body["thumbnail_url"],
      thumbnail_width: body["thumbnail_width"],
      thumbnail_height: body["thumbnail_height"],
      url: body["url"],
      width: body["width"],
      height: body["height"]
    }
  end

  defp decode_oembed_response(%{"type" => "video"} = body) do
    %ReqEmbed.Video{
      type: body["type"],
      version: body["version"],
      title: body["title"],
      author_name: body["author_name"],
      author_url: body["author_url"],
      provider_name: body["provider_name"],
      provider_url: body["provider_url"],
      cache_age: body["cache_age"],
      thumbnail_url: body["thumbnail_url"],
      thumbnail_width: body["thumbnail_width"],
      thumbnail_height: body["thumbnail_height"],
      html: body["html"],
      width: body["width"],
      height: body["height"]
    }
  end

  defp decode_oembed_response(%{"type" => "rich"} = body) do
    %ReqEmbed.Rich{
      type: body["type"],
      version: body["version"],
      title: body["title"],
      author_name: body["author_name"],
      author_url: body["author_url"],
      provider_name: body["provider_name"],
      provider_url: body["provider_url"],
      cache_age: body["cache_age"],
      thumbnail_url: body["thumbnail_url"],
      thumbnail_width: body["thumbnail_width"],
      thumbnail_height: body["thumbnail_height"],
      html: body["html"],
      width: body["width"],
      height: body["height"]
    }
  end

  defp decode_oembed_response(body) do
    %ReqEmbed.Link{
      type: body["type"],
      version: body["version"],
      title: body["title"],
      author_name: body["author_name"],
      author_url: body["author_url"],
      provider_name: body["provider_name"],
      provider_url: body["provider_url"],
      cache_age: body["cache_age"],
      thumbnail_url: body["thumbnail_url"],
      thumbnail_width: body["thumbnail_width"],
      thumbnail_height: body["thumbnail_height"]
    }
  end

  @doc """
  Render the oEmbed content as HTML.

  ## Options

    * `:class` (`t:String.t/0`) - Defaults to `nil`. CSS class to be added into the <iframe> tag, if used it removes both `width` and `height` attributes.
    * `:include_caption` (`t:boolean/0`) - Defaults to `true`. When enabled, it will include the photo title in `<figcaption>`.

  ## Examples

      iex> ReqEmbed.html("https://www.youtube.com/watch?v=XfELJU1mRMg")
      <iframe width="200" height="113" src="https://www.youtube.com/embed/XfELJU1mRMg?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen title="Rick Astley - Never Gonna Give You Up (Official Music Video)"></iframe>

  Replace the `width` and `height` attributes with a CSS class:

      iex> ReqEmbed.html("https://www.youtube.com/watch?v=XfELJU1mRMg", class: "aspect-video")
      <iframe class="aspect-video" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen="allowfullscreen" frameborder="0" referrerpolicy="strict-origin-when-cross-origin" src="https://www.youtube.com/embed/XfELJU1mRMg?feature=oembed" title="Rick Astley - Never Gonna Give You Up (Official Music Video)"></iframe>

  Wrap it in a `{:safe, html}` tuple or call `Phoenix.HTML.raw/1` to render it in Phoenix templates.

  """
  def html(url, opts \\ []) when is_binary(url) and is_list(opts) do
    class = opts[:class]
    include_caption = Keyword.get(opts, :include_caption, true)

    req = Req.new() |> ReqEmbed.attach()

    case Req.get(req, url: url) do
      {:ok, %{body: %{html: html}}} when is_binary(html) ->
        cond do
          !class ->
            html

          {:ok, [{tag, attrs, children}]} = Floki.parse_fragment(html, attributes_as_maps: true) ->
            attrs =
              attrs
              |> Map.drop(["width", "height"])
              |> append_class(class)

            Floki.raw_html([{tag, attrs, children}])
        end

      {:ok, %{body: %ReqEmbed.Photo{} = photo}} ->
        caption =
          if include_caption do
            {:safe, title} = Phoenix.HTML.html_escape(photo.title || "")
            ["  ", "<figcaption>", title, "</figcaption>", "\n"]
          else
            []
          end

        {:safe, attrs} =
          Phoenix.HTML.attributes_escape(%{
            "src" => photo.url,
            "alt" => photo.title,
            "width" => photo.width,
            "height" => photo.height,
            "loading" => "lazy"
          })

        IO.iodata_to_binary([
          "<figure>",
          "\n",
          "  <img",
          [attrs],
          " />",
          "\n",
          caption,
          "</figure>"
        ])

      _ ->
        "<span>Unsupported embed type</span>"
    end
  end

  @doc false
  def append_class(%{"class" => class} = attrs, new_class) when is_binary(new_class) do
    class = String.split(class, " ")

    class =
      [new_class | class]
      |> Enum.reverse()
      |> Enum.join(" ")

    Map.put(attrs, "class", class)
  end

  def append_class(attrs, new_class) when is_binary(new_class),
    do: Map.put(attrs, "class", new_class)

  def append_class(attrs, _), do: attrs

  if Code.ensure_loaded?(Phoenix.Component) do
    use Phoenix.Component

    attr(:url, :string, required: true, doc: "URL of the resource to be embedded")

    attr(:class, :string,
      required: false,
      doc:
        "CSS class to be added into the <iframe> tag, if used it removes both width and height attributes"
    )

    attr(:include_caption, :boolean,
      required: false,
      default: true,
      doc: "When enabled, it will include the photo title in <figcaption>"
    )

    @doc """
    Phoenix Component to render oEmbed content.

    Requires [phoenix_live_view](https://hex.pm/packages/phoenix_live_view) to be installed,
    otherwise you can use `html/2` directly.

    This component is essentially a wrapper for `html/2`.

    ## Example

        def render(assigns) do
          ~H\"\"\"
          <%= ReqEmbed.embed(url: "https://www.youtube.com/watch?v=XfELJU1mRMg") %>
          \"\"\"
        end

    """
    def embed(assigns) do
      assigns =
        assign(assigns,
          html:
            html(assigns[:url],
              class: assigns[:class],
              include_caption: assigns[:include_caption]
            )
        )

      ~H"""
      <%= Phoenix.HTML.raw(@html) %>
      """
    end
  else
    def embed(_assigns) do
      raise """
      :phoenix_live_view is required to use ReqEmbed.embed/1
      """
    end
  end
end
