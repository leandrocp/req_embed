defmodule ReqEmbed.MixProject do
  use Mix.Project

  @source_url "https://github.com/BeaconCMS/req_embed"
  @version "0.2.0"

  def project do
    [
      app: :req_embed,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      package: package(),
      docs: docs(),
      deps: deps(),
      aliases: aliases(),
      name: "ReqEmbed",
      source_url: @source_url,
      description: "oEmbed plugin for Req and Phoenix Component to embed rich content"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def cli do
    [
      preferred_envs: [
        docs: :docs,
        "hex.publish": :docs
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Leandro Pereira"],
      licenses: ["MIT"],
      links: %{
        Changelog: "https://hexdocs.pm/req_embed/changelog.html",
        GitHub: @source_url,
        DockYard: "https://dockyard.com"
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
      {:phoenix_html, "~> 3.0 or ~> 4.0"},
      {:phoenix_live_view, "~> 0.20 or ~> 1.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :docs, warn_if_outdated: true},
      {:makeup_elixir, "~> 1.0", only: :docs},
      {:makeup_eex, "~> 2.0", only: :docs},
      {:makeup_syntect, "~> 0.1", only: :docs}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "compile"],
      dev: ["cmd iex demo.exs"]
    ]
  end
end
