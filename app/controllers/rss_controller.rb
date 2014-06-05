class RssController < ApplicationController
  def posts
    @posts = Post.includes(:user).order('created_at DESC').limit(50).all
  end
end
