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
      @user.email=params['user']['email']
      if @user.save
        redirect_to root_path
        return
      else
        render 'users/show', locals:{@user => @user}
        return
      end
    end
    redirect_to root_path
  end
end
