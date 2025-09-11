module FaviconHelper
  def favicon_image_tag(domain, **kwargs)
    image_tag "https://www.google.com/s2/favicons?domain=#{domain}"
  end
end
