class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to root_path, :alert => "Makeupedia could not log you in at this time. Please check your email and password and try again."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
