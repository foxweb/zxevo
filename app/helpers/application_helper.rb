module ApplicationHelper
  def fresh_posts
    Post.fresh
  end
end
