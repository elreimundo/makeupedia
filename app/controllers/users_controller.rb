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
    if current_user && current_user.id == params[:id].to_i
      @user = current_user
    else
      redirect_to :root
    end
  end

  def update
    @user = current_user
    if params['id'].to_i == current_user.id
      if @user.update_attributes(params['user'])
        redirect_to user_path, :notice => 'Your profile has been updated!'
      else
        redirect_to user_path, :notice => 'Sorry, your profile could not be updated.'
      end
    else
      redirect_to root_path
    end
  end
end
