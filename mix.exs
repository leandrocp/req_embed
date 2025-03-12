defmodule ReqEmbed.MixProject do
  use Mix.Project

  @source_url "https://github.com/BeaconCMS/req_embed"
  @version "0.1.0-dev"

  def project do
    [
      app: :req_embed,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      package: package(),
      docs: docs(),
      deps: deps(),
      name: "ReqEmbed",
      source_url: @source_url,
      description: "oEmbed plugin for Req"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Leandro Pereira"],
      licenses: ["MIT"],
      links: %{
        Changelog: "https://hexdocs.pm/req_embed/changelog.html",
        GitHub: @source_url
      },
      files: [
        "mix.exs",
        "lib",
        "priv",
        "README.md",
        "LICENSE",
        "CHANGELOG.md"
      ]
    ]
  end

  defp docs do
    [
      main: "ReqEmbed",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["CHANGELOG.md"],
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.4"},
      {:floki, "~> 0.35"},
      {:jason, "~> 1.0"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end
end
