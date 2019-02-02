class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    if user
      session[:session_token] = user.reset_session_token!
      redirect_to user_url(user)
    else
      flash.now[:errors] = user.errors.full_messages
      render :new
    end
  end

  def destroy
    user.reset_session_token!
    session[:session_token] = nil
  end
end
