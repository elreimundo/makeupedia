class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :mobile_device?
  helper_method :users_show

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end

end
