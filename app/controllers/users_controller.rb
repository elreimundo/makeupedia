class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    if current_user.id == params[:id].to_i
      @user = User.find(session[:user_id])
    else
      redirect_to :root
    end

  end
end
