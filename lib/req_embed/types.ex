defmodule ReqEmbed.Content do
  @moduledoc """
  Base oEmbed response parameters as defined in https://oembed.com/#section2.3.4

  These are the common fields that all oEmbed response types may include:
  * `type` (required) - The resource type. Valid values are: photo, video, link, rich
  * `version` (required) - The oEmbed version number. Must be "1.0"
  * `title` (optional) - A text title describing the resource
  * `author_name` (optional) - The name of the author/owner of the resource
  * `author_url` (optional) - A URL for the author/owner of the resource
  * `provider_name` (optional) - The name of the resource provider
  * `provider_url` (optional) - The url of the resource provider
  * `cache_age` (optional) - The suggested cache lifetime for this resource, in seconds
  * `thumbnail_url` (optional) - A URL to a thumbnail image representing the resource
  * `thumbnail_width` (optional) - The width of the optional thumbnail
  * `thumbnail_height` (optional) - The height of the optional thumbnail

  Note: If thumbnail_url is present, thumbnail_width and thumbnail_height must also be present.
  """

  defstruct [
    :type,
    :version,
    :title,
    :author_name,
    :author_url,
    :provider_name,
    :provider_url,
    :cache_age,
    :thumbnail_url,
    :thumbnail_width,
    :thumbnail_height
  ]
end

defmodule ReqEmbed.Photo do
  @moduledoc """
  The photo type as defined in https://oembed.com/#section2.3.4.1

  Represents a static photo. Includes all base Content fields plus:
  * `url` (required) - The source URL of the image. Consumers should be able to insert this URL into an <img> element. Only HTTP and HTTPS URLs are valid
  * `width` (required) - The width in pixels of the image specified in the url parameter
  * `height` (required) - The height in pixels of the image specified in the url parameter

  Photo responses must obey the maxwidth and maxheight request parameters.
  """

  defstruct [
    :type,
    :version,
    :title,
    :author_name,
    :author_url,
    :provider_name,
    :provider_url,
    :cache_age,
    :thumbnail_url,
    :thumbnail_width,
    :thumbnail_height,
    :url,
    :width,
    :height
  ]
end

defmodule ReqEmbed.Video do
  @moduledoc """
  The video type as defined in https://oembed.com/#section2.3.4.2

  Represents a playable video. Includes all base Content fields plus:
  * `html` (required) - The HTML required to embed a video player. The HTML should have no padding or margins
  * `width` (required) - The width in pixels required to display the HTML
  * `height` (required) - The height in pixels required to display the HTML

  Video responses must obey the maxwidth and maxheight request parameters.
  If a provider wishes the consumer to just provide a thumbnail rather than an embeddable player,
  they should instead return a photo response type.
  """

  defstruct [
    :type,
    :version,
    :title,
    :author_name,
    :author_url,
    :provider_name,
    :provider_url,
    :cache_age,
    :thumbnail_url,
    :thumbnail_width,
    :thumbnail_height,
    :html,
    :width,
    :height
  ]
end

defmodule ReqEmbed.Rich do
  @moduledoc """
  The rich type as defined in https://oembed.com/#section2.3.4.4

  Used for rich HTML content that does not fall under other categories. Includes all base Content fields plus:
  * `html` (required) - The HTML required to display the resource. The HTML should have no padding or margins.
    The markup should be valid XHTML 1.0 Basic
  * `width` (required) - The width in pixels required to display the HTML
  * `height` (required) - The height in pixels required to display the HTML

  Rich responses must obey the maxwidth and maxheight request parameters.
  Consumers may wish to load the HTML in an off-domain iframe to avoid XSS vulnerabilities.
  """

  defstruct [
    :type,
    :version,
    :title,
    :author_name,
    :author_url,
    :provider_name,
    :provider_url,
    :cache_age,
    :thumbnail_url,
    :thumbnail_width,
    :thumbnail_height,
    :html,
    :width,
    :height
  ]
end

defmodule ReqEmbed.Link do
  @moduledoc """
  The link type as defined in https://oembed.com/#section2.3.4.3

  The simplest type that allows a provider to return any generic embed data without providing
  either the url or html parameters. Only includes the base Content fields.

  The consumer may then link to the resource using the URL specified in the original request.
  This type is useful when the resource cannot be embedded or when the consumer should just
  provide a direct link to the resource.
  """

  defstruct [
    :type,
    :version,
    :title,
    :author_name,
    :author_url,
    :provider_name,
    :provider_url,
    :cache_age,
    :thumbnail_url,
    :thumbnail_width,
    :thumbnail_height
  ]
end
