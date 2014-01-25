class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user).order('created_at DESC').all

    respond_to do |format|
      format.html
      format.json { render json: @posts }
      format.rss  { render rss:  @posts, layout: 'rss' }
    end
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end
end
