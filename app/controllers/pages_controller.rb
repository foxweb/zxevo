class PagesController < ApplicationController

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page = Page.where(slug: params[:slug]).first

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end
end
