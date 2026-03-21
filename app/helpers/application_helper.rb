module ApplicationHelper
  def fresh_posts
    Post.fresh
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  # Полный URL: app_url('/rss'), app_url(post_path(@post))
  def app_url(path = '')
    base = Rails.application.config.x.app_url
    return base if path.blank?

    path = path.start_with?('/') ? path : "/#{path}"
    "#{base}#{path}"
  end

  # Хост из APP_URL (для RSS image title, GA cookie domain и т.п.)
  def app_host
    @app_host ||= URI.parse(Rails.application.config.x.app_url).host
  end
end
