class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: create_params[:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render :new
    end
  end

  def edit

  end

  def update
    if password_blank?
      flash.now[:danger] = "Password can't be blank"
      render :edit
    elsif @user.update_attributes(update_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def create_params
    params.require(:password_reset).permit(:email)
  end

  def update_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Returns true if password is blank.
  def password_blank?
    update_params[:password].blank?
  end

  def get_user
    @user = User.find_by(email: params.require(:email))
  end

  # Confirms a valid user.
  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params.require(:id)))
      redirect_to root_url
    end
  end

  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
