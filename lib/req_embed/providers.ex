defmodule ReqEmbed.Providers do
  @moduledoc false

  @external_resource "priv/providers.json"

  @popular_providers [
    "YouTube",
    "Facebook",
    "Instagram",
    "Twitter",
    "TikTok",
    "LinkedIn",
    "Pinterest",
    "Vimeo",
    "Spotify",
    "SoundCloud",
    "Dailymotion",
    "Giphy",
    "Twitch",
    "Reddit",
    "Flickr",
    "CodePen",
    "Figma",
    "Canva",
    "Loom",
    "Miro"
  ]

  @providers Path.join([Application.app_dir(:req_embed), "priv/providers.json"])
             |> File.read!()
             |> Jason.decode!()
             |> Enum.map(fn provider ->
               endpoints =
                 Enum.map(provider["endpoints"] || [], fn endpoint ->
                   %{
                     url: String.replace(endpoint["url"], "{format}", "json") |> URI.new!(),
                     schemes:
                       Enum.map(endpoint["schemes"] || [], fn pattern ->
                         pattern
                         |> String.replace(".", "\\.")
                         |> String.replace("*", ".*")
                       end)
                   }
                 end)

               %{
                 name: provider["provider_name"],
                 url: provider["provider_url"],
                 endpoints: endpoints
               }
             end)

  @popular_provider_list Enum.filter(@providers, &(&1.name in @popular_providers))
  @other_provider_list Enum.filter(@providers, &(&1.name not in @popular_providers))

  def all, do: @providers

  def get_by_url(url) when is_binary(url) do
    case find_matching_provider(@popular_provider_list, url) do
      nil -> find_matching_provider(@other_provider_list, url)
      provider -> provider
    end
  end

  defp find_matching_provider(providers, url) do
    Enum.find(providers, fn provider ->
      Enum.any?(provider.endpoints, fn endpoint ->
        Enum.any?(endpoint.schemes, fn pattern ->
          Regex.match?(~r/#{pattern}/, url)
        end)
      end)
    end)
  end
end
