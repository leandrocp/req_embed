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
  end

  describe "oembed" do
    test "returns the embedded type" do
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
  end

  describe "discover from link" do
    test "find the embedded endpoint" do
      assert %URI{
               scheme: "https",
               host: "www.youtube.com",
               path: "/oembed",
               query: "format=json&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DXfELJU1mRMg"
             } = ReqEmbed.discover_link("https://www.youtube.com/watch?v=XfELJU1mRMg")
    end
  end

  describe "discover from provider" do
  end
end
