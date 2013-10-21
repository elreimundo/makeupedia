class WikisController < ApplicationController
  include WikisHelper

  def create
    if current_user && !params[:url].empty?
      page = current_user.pages.where('url=?', params[:url])
      page.empty? ? page = current_user.pages.create(:url => params[:url]) : page = page.first
      page_user = PageUser.where('user_id=?',current_user.id).where('page_id=?',page.id).first
      page_user.changes.create(:find_text => params[:search], :replace_text => params[:replace])
    end

    data = build_the_json(params)
    render json: data.to_json
  end

  def show
    if current_user
      params[:user_id] = current_user.id
      data = apply_lots_of_changes(params)
      render json: data.to_json
    else
      redirect_to root_path
    end
  end

  def revise
    render template: 'wikis/revise', layout: 'lazy_load'
  end

  def reconstructed
    Page.where()
  end
end
