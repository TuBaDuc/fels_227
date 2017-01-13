class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      add_activity Activity.action_types[:login]
      redirect_back_or user
    else
      flash.now[:danger] = t :invalid_email_password
      render :new
    end
  end

  def destroy
    if logged_in?
      add_activity Activity.action_types[:logout]
      log_out
    end
    redirect_to root_url
  end
end
