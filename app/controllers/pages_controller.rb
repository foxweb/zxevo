class PagesController < ApplicationController
  def show
    @page = Page.where(slug: params[:slug], is_visible: true).first
    not_found unless @page

    respond_to do |format|
      format.html
      format.json { render json: @page }
    end
  end
end
