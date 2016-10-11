# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://chowbrowser.com"

SitemapGenerator::Sitemap.create do
  add about_path, :priority => 0.9
  add about_delivery_path, :priority => 0.8
  add faq_path, :priority => 0.7
  add public_restaurants_path, :priority => 0.6
  add public_menus_path
  add promote_restaurant_path, :priority => 0.4
  add contacts_path, :priority => 0.3
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
