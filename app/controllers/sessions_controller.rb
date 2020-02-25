class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: create_params[:email].downcase)
    if user && user.authenticate(create_params[:password])
      log_in user
      create_params[:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid login credentials supplied'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def create_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
