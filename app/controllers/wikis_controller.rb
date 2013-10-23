class WikisController < ApplicationController
  include WikisHelper

  def create
    puts params
    if current_user && !params[:ending].empty?
      page = current_user.pages.where('ending=?', params[:ending].capitalize)
      page = (page.empty? ? current_user.pages.create(:ending => params[:ending].capitalize) : page.first)
      page_user = PageUser.where('user_id=?',current_user.id).where('page_id=?',page.id)
      page_user = (page_user.empty? ? PageUser.create(:user_id => current_user.id, :page_id => page.id) : page_user.first)
      page_user.changes.create(:find_text => params[:search], :replace_text => params[:replace])
      redirect_to root_path
    else
      # anonymous, don't save nothing man
      render :nothing => true
    end

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
    @ending = params[:page]
    page = Page.where('ending=?',@ending.split('_').join(' ').capitalize)
    page = (page.empty? ? page = Page.create(:ending => @ending.split('_').join(' ')) : page.first)
    if current_user
      page_user = PageUser.where(:user_id => current_user.id).where(:page_id => page.id)
      page_user = (page_user.empty? ? PageUser.create(:user_id => current_user.id, :page_id => page.id) : page_user.first)
    end
    render template: 'wikis/revise', layout: 'lazy_load'
  end

  def reconstruct
    page = params[:page]
    user_id = params[:user_id]
    render json: display_the_stuff_with_changes(page, user_id).to_json
    # associate that page with the user that is passed in through params[:user_id]
    # if no params[:user_id], associate with current_user
    # if no params[:user_id] and no current_user, just pull in the wikipedia text
  end

  def director
    redirect_to '/wiki/' + params['ending']
  end
end
