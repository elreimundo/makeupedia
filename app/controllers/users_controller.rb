class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(email: params[:email], password: params[:password])
    if @user.save
      puts "Yes! Victory!"
    else
      puts "Oh, noes!!!"
    end
  end
end
