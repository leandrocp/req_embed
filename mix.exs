defmodule ReqEmbed.MixProject do
  use Mix.Project

  def project do
    [
      app: :req_embed,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "ReqEmbed",
      source_url: "https://github.com/BeaconCMS/req_embed",
      docs: [
        main: "ReqEmbed",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
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
