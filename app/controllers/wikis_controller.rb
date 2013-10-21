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

  def reconstruct
    # page = Page.where('ending=?',params[:page])
    # page = Page.create(ending: params[:page]) unless page
    # param[:user_id] ? page_user = PageUser.where('user_id=?',params[:user_id]) : fishsticks
    render json: just_display_the_stuff(params[:page]).to_json
    # associate that page with the user that is passed in through params[:user_id]
    # if no params[:user_id], associate with current_user
    # if no params[:user_id] and no current_user, just pull in the wikipedia text
  end
end
