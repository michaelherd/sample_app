class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params.require(:email))
    if user && !user.activated? && user.authenticated?(:activation, params.require(:id))
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end