class SessionsController < ApplicationController
  before_action :redirect_home_if_signed_in, only: [:new, :create]

  def new
    @signin_page = true
    render :new
  end

  def create
    user = User.find_by_credentials(session_params)
    
    if user
      login_user!(user)
    else
      flash.now[:errors] = "Incorrect credentials"
      redirect_to :new
    end
  end

  def destroy
    if current_user
      Session.find_by(session_token: session[:session_token]).destroy
      session[:session_token] = nil
    end

    redirect_to cats_url
  end

  private
  def session_params
    params.require(:user).permit(:username, :password)
  end
end
