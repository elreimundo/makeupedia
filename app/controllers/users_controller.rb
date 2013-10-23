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

    redirect_to root_path, :notice => 'Please sign in to see your profile.' and return unless params['id'].to_i == current_user.id

    if params['user']['email'].present? == true
      change_email
      return
    elsif  params['user']['current_password'].present? && @user.password == params['user']['current_password']
      change_password
      return
    else
      redirect_to user_path, :notice => 'Please check your information before updating.'
      return
    end
  end

  def change_email
    current_user.email = params['user']['email']
    if current_user.save
      redirect_to user_path, :notice => 'Your email has been updated!'
    else
      redirect_to user_path, :notice => 'Sorry that email is already in use.'
    end
  end

  def change_password
    if params['user']['password'].length > 0 && params['user']['password'] == params['user']['password_confirmation']
      current_user.password = params['user']['password']
      current_user.save
      redirect_to user_path, :notice => 'Your password has been updated!'
    else
      redirect_to user_path, :notice => 'Your new password does not match.'
    end
  end
end
