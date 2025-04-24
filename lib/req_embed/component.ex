if Code.ensure_loaded?(Phoenix.HTML) && Code.ensure_loaded?(Phoenix.Component) do
  defmodule ReqEmbed.Component do
    @moduledoc """
    Phoenix LiveView Components to embed rich content using oEmbed.

    Adding `:phoenix_live_view` to your dependencies is required to use this module.
    """

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

    def embed(assigns) do
      assigns =
        assign(assigns,
          html:
            ReqEmbed.html(assigns[:url],
              class: assigns[:class],
              include_caption: assigns[:include_caption]
            )
        )

      ~H"""
      <%= Phoenix.HTML.raw(@html) %>
      """
    end
  end
else
  defmodule ReqEmbed.Component do
    def embed(_assigns) do
      raise """
      :phoenix_live_view is required to use ReqEmbed.Component.embed/1
      """
    end
  end
end
