class WikisController < ApplicationController
  include WikisHelper

  def create
    @page = Page.create(:url => params[:url])
    @change = Change.create(:find_text => params[:search], :replace_text => params[:replace])

    data = build_the_json(params)
    render json: data.to_json
  end

end
