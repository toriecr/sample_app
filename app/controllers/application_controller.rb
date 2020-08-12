class ApplicationController < ActionController::Base
  include SessionsHelper
  
  private

    # Confirms a logged-in user.
    # Moved from UsersController to here since both Users and Microposts controller needs this method
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
  
end
