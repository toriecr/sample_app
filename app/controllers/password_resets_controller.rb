class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Checks for expired password reset
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty? # Failed update due to an empty password and confirmation
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params) # Successful update
      @user.forget # Guard against session hijacking
      reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit' # Failed update due to invalid password
    end
  end
  
  private
    
    # Permitting both the password and password confirmation attributes
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Before filters
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user
    def valid_user
      unless (@user && @user.activated? &&
        @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # Checks expiration of reset token
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
