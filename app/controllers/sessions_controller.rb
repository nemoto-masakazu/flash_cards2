class SessionsController < ApplicationController
  skip_before_action :user_logged_in?

  def new
    if session[:user_id] != nil
      redirect_to "/top"
    else
      render "sessions/new"
    end
  end

  def create
    user = User.find_by(name: params[:session][:name].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to "/top"

    else
      flash.now[:danger] = "Invalid name/password combination"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to "/sessions/login"
  end
end
