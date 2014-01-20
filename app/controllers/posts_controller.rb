class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.includes(:user).order('created_at DESC').all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.rss  { render rss:  @posts, layout: 'rss' }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
end
