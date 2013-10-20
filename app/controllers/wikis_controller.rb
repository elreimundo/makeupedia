class WikisController < ApplicationController
  include WikisHelper

  def create
    if current_user
      @page = Page.create(:url => params[:url])
      @change = Change.create(:find_text => params[:search], :replace_text => params[:replace])
    end

    data = build_the_json(params)
    render json: data.to_json
  end

end
