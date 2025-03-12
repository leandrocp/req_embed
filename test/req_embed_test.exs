defmodule ReqEmbedTest do
  use ExUnit.Case

  describe "providers" do
    test "loads all providers" do
      assert ReqEmbed.Providers.all() |> length() == 331
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
                     schemes: [~r/http:\/\/www\.23hq\.com\/.*\/photo\/.*/]
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
end
