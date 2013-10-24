class PageUsersController < ApplicationController
  def destroy
    @page_user = PageUser.find(params[:id].to_i)
    @page_user.destroy
    redirect_to root_path
  end
end
