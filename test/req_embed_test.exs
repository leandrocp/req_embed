defmodule ReqEmbedTest do
  use ExUnit.Case

  describe "providers" do
    test "loads all providers" do
      assert ReqEmbed.Providers.all() |> length() > 0
    end

    test "format" do
      assert [
               %{
                 name: "23HQ",
                 url: "http://www.23hq.com",
                 endpoints: [
                   %{
                     url: %URI{
                       scheme: "http",
                       userinfo: nil,
                       host: "www.23hq.com",
                       port: 80,
                       path: "/23/oembed",
                       query: nil,
                       fragment: nil
                     },
                     schemes: ["http://www\\.23hq\\.com/.*/photo/.*"]
                   }
                 ]
               }
               | _
             ] = ReqEmbed.Providers.all()
    end

    test "get_by_url returns provider when URL matches scheme" do
      assert %{name: "YouTube"} =
               ReqEmbed.Providers.get_by_url("https://www.youtube.com/watch?v=XfELJU1mRMg")
    end

    test "get_by_url returns nil when URL doesn't match any provider" do
      refute ReqEmbed.Providers.get_by_url("http://unknown-provider.com/photo/1234")
    end
  end

  describe "oembed" do
    test "discover the video type" do
      req = Req.new() |> ReqEmbed.attach()

      assert %ReqEmbed.Video{
               type: "video",
               version: "1.0",
               html: html,
               width: 200,
               height: 113
             } = Req.get!(req, url: "https://www.youtube.com/watch?v=XfELJU1mRMg").body

      assert html =~ "iframe"
    end

    test "works with discover: false using known provider endpoint" do
      req = Req.new() |> ReqEmbed.attach(discover: false)

      assert %ReqEmbed.Video{
               type: "video",
               version: "1.0",
               title: "Rick Astley - Never Gonna Give You Up (Official Music Video)",
               provider_name: "YouTube",
               html: html
             } = Req.get!(req, url: "https://www.youtube.com/watch?v=XfELJU1mRMg").body

      assert html =~ "iframe"
    end

    test "discover the rich type" do
      req = Req.new() |> ReqEmbed.attach()

      assert %ReqEmbed.Rich{
               type: "rich",
               version: "1.0",
               title: nil,
               width: 550,
               author_name: "ThinkingElixir",
               author_url: "https://twitter.com/ThinkingElixir",
               provider_name: "Twitter",
               provider_url: "https://twitter.com",
               html: html
             } =
               Req.get!(req, url: "https://x.com/ThinkingElixir/status/1848702455313318251").body

      assert html =~ "blockquote"
    end
  end

  defp assert_html(url, expected, opts \\ []) do
    html = ReqEmbed.html(url, opts)
    # IO.puts(html)
    assert String.trim(html) =~ String.trim(expected)
  end

  test "append_class" do
    assert ReqEmbed.append_class(%{}, "foo") == %{"class" => "foo"}
    assert ReqEmbed.append_class(%{"class" => "foo"}, "foo") == %{"class" => "foo foo"}
    assert ReqEmbed.append_class(%{"class" => "foo"}, "bar") == %{"class" => "foo bar"}
  end

  describe "html: video" do
    test "render" do
      assert_html(
        "https://www.youtube.com/watch?v=XfELJU1mRMg",
        """
        <iframe width="200" height="113" src="https://www.youtube.com/embed/XfELJU1mRMg?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen title="Rick Astley - Never Gonna Give You Up (Official Music Video)"></iframe>
        """
      )
    end

    test "add class" do
      assert_html(
        "https://www.youtube.com/watch?v=XfELJU1mRMg",
        """
        <iframe allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen="allowfullscreen" class="aspect-video" frameborder="0" referrerpolicy="strict-origin-when-cross-origin" src="https://www.youtube.com/embed/XfELJU1mRMg?feature=oembed" title="Rick Astley - Never Gonna Give You Up (Official Music Video)"></iframe>
        """,
        class: "aspect-video"
      )
    end
  end

  describe "html: image" do
    test "render" do
      html = ReqEmbed.html("https://giphy.com/gifs/need-pR8zHItvQDvBC")

      assert html =~
               ~s|<img alt="Terry Crews Need GIF - Find &amp; Share on GIPHY" height="281" loading="lazy" src=|

      assert html =~ ~s|giphy.com/media/pR8zHItvQDvBC/giphy.gif|
      assert html =~ ~s|<figcaption>Terry Crews Need GIF - Find &amp; Share on GIPHY</figcaption>|
    end

    test "do not include caption" do
      html = ReqEmbed.html("https://giphy.com/gifs/need-pR8zHItvQDvBC", include_caption: false)
      refute html =~ "<figcaption>"
    end
  end

  describe "html: rich" do
    test "render" do
      assert_html(
        "https://codepen.io/juliangarnier/pen/krNqZO",
        """
        <iframe id="cp_embed_idhuG" src="https://codepen.io/juliangarnier/embed/preview/idhuG?default-tabs=css%2Cresult&amp;height=300&amp;host=https%3A%2F%2Fcodepen.io&amp;slug-hash=idhuG" title="CSS 3D Solar System" scrolling="no" frameborder="0" height="300" allowtransparency="true" class="cp_embed_iframe" style="width: 100%; overflow: hidden;"></iframe>
        """
      )
    end

    test "append class" do
      assert_html(
        "https://codepen.io/juliangarnier/pen/krNqZO",
        """
        <iframe allowtransparency="true" class="cp_embed_iframe aspect-square" frameborder="0" id="cp_embed_idhuG" scrolling="no" src="https://codepen.io/juliangarnier/embed/preview/idhuG?default-tabs=css%2Cresult&amp;height=300&amp;host=https%3A%2F%2Fcodepen.io&amp;slug-hash=idhuG" style="width: 100%; overflow: hidden;" title="CSS 3D Solar System"></iframe>
        """,
        class: "aspect-square"
      )
    end
  end

  if Code.ensure_loaded(Phoenix.Component) do
    import Phoenix.Component

    defp assert_rendered(template, expected) do
      rendered = Phoenix.LiveViewTest.rendered_to_string(template)
      # IO.puts(rendered)
      assert String.trim(rendered) == String.trim(expected)
    end

    describe "component: video" do
      test "render" do
        assigns = %{url: "https://www.youtube.com/watch?v=XfELJU1mRMg"}

        assert_rendered(
          ~H"""
          <ReqEmbed.embed url={@url} />
          """,
          """
          <iframe width="200" height="113" src="https://www.youtube.com/embed/XfELJU1mRMg?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen title="Rick Astley - Never Gonna Give You Up (Official Music Video)"></iframe>
          """
        )
      end
    end

    describe "component: image" do
      test "render" do
        assigns = %{url: "https://giphy.com/gifs/need-pR8zHItvQDvBC"}

        html =
          ~H"""
          <ReqEmbed.embed url={@url} />
          """
          |> Phoenix.LiveViewTest.rendered_to_string()

        assert html =~
                 ~s|<img alt="Terry Crews Need GIF - Find &amp; Share on GIPHY" height="281" loading="lazy" src=|

        assert html =~ ~s|giphy.com/media/pR8zHItvQDvBC/giphy.gif|

        assert html =~
                 ~s|<figcaption>Terry Crews Need GIF - Find &amp; Share on GIPHY</figcaption>|
      end
    end

    describe "component: rich" do
      test "render" do
        assigns = %{url: "https://codepen.io/juliangarnier/pen/krNqZO"}

        assert_rendered(
          ~H"""
          <ReqEmbed.embed url={@url} />
          """,
          """
          <iframe id="cp_embed_idhuG" src="https://codepen.io/juliangarnier/embed/preview/idhuG?default-tabs=css%2Cresult&amp;height=300&amp;host=https%3A%2F%2Fcodepen.io&amp;slug-hash=idhuG" title="CSS 3D Solar System" scrolling="no" frameborder="0" height="300" allowtransparency="true" class="cp_embed_iframe" style="width: 100%; overflow: hidden;"></iframe>
          """
        )
      end
    end
  end
end
