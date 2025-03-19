Mix.install([
  {:phoenix_playground, "~> 0.1"},
  {:phoenix_html, "~> 4.0"},
  {:phoenix_live_view, "~> 1.0"},
  {:req, "~> 0.5"},
  {:req_embed, path: "."}
])

defmodule DemoLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

    <body class="min-h-screen">
      <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold mt-8">.embed video</h1>
        <ReqEmbed.embed url="https://www.youtube.com/watch?v=XfELJU1mRMg" class="aspect-video rounded-lg w-md" />

        <h1 class="text-3xl font-bold mt-8">html video</h1>
        <%= Phoenix.HTML.raw(ReqEmbed.html("https://www.youtube.com/watch?v=XfELJU1mRMg", class: "aspect-video rounded-lg w-md")) %>

        <h1 class="text-3xl font-bold mt-8">.embed rich</h1>
        <ReqEmbed.embed url="https://codepen.io/juliangarnier/pen/krNqZO" class="aspect-square" />

        <h1 class="text-3xl font-bold mt-8">html rich</h1>
        <%= {:safe, ReqEmbed.html("https://codepen.io/juliangarnier/pen/krNqZO", class: "aspect-square")} %>
      </div>
    </body>
    """
  end
end

PhoenixPlayground.start(live: DemoLive, open_browser: true)
