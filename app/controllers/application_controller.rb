class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  before_filter :expire_sessions
  #before_filter :require_login
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

    def expire_sessions
      Session.sweep("1 day")
      #reset_session
    end
=begin
    def current_user
      #@current_user ||= User.find(session[:user_id]) if session[:user_id]
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    end
    helper_method :current_user
=end
  protected

    def not_authenticated
      redirect_to root_path, :alert => "Please login first."
    end
end
