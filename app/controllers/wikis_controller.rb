class WikisController < ApplicationController
  include WikisHelper

  def create
    if current_user && !params[:ending].empty?
      page = Page.find_by(ending: standardize(params[:ending]))
      page_user = PageUser.find_or_create_by(:user_id => current_user.id, :page_id => page.id)
      page_user.changes.create(:ending => standardize(params[:ending]), :find_text => params[:search], :replace_text => params[:replace])
      redirect_to root_path
    else
      # anonymous, don't save nothing man
      render :nothing => true
    end

  end

  def revise
    @ending = params[:ending].capitalize
    page = Page.find_or_create_by(:ending => standardize(@ending))
    if current_user
      page_user = PageUser.find_or_create_by(:user_id => current_user.id, :page_id => page.id)
    end
    render template: 'wikis/revise', layout: 'lazy_load'
  end

  def reconstruct
    ending = params[:ending]
    user_id = params[:user_id] || current_user.id if (params[:user_id] || current_user)
    changes = user_id ? User.find(user_id).changes_for_page(ending) : []
    render json: get_modified_wikipedia_body(ending, changes).to_json
    # associate that page with the user that is passed in through params[:user_id]
    # if no params[:user_id], associate with current_user
    # if no params[:user_id] and no current_user, just pull in the wikipedia text
  end
end
