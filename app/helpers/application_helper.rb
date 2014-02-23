module ApplicationHelper
  def fresh_posts
    Post.fresh
  end

  def title(page_title)
    content_for(:title) { page_title }
  end
end
