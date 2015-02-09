class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :user_authenticate!

  helper_method :current_user, :user_signed_in?

  def current_user
    User.find(session[:user_uuid]) rescue nil
  end

  def user_signed_in?
    current_user.present?
  end

  def user_authenticate!
    redirect_to login_path unless user_signed_in?
  end
end
