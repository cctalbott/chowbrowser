class AdminController < ApplicationController
  before_filter :layout => "admin"
  before_filter :is_allowed?

  def index
  end

  private

    def is_allowed?
      unless(current_user.role?(:admin) || current_user.role?(:restaurant_owner) || current_user.role?(:restaurant_editor))
        redirect_to new_user_session_path, :alert => "You must be signed in as an administrator to view the admin section."
      end
    end
end
