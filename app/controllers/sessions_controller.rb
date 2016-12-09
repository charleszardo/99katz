class SessionsController < ApplicationController
  before_action :disallow_if_signed_in, only: [:new, :create]

  def new
    @signin_page = true
    
    render :new
  end

  def create
    user = User.find_by_credentials(session_params)
    if user
      login_user!(user)
      redirect_to cats_url
    else
      flash.now[:errors] = "Incorrect credentials"
      redirect_to :new
    end
  end

  def destroy
    if current_user
      destroy_sesh = Session.find(params[:id])
      session[:session_token] = nil if destroy_sesh.session_token == session[:session_token]
      destroy_sesh.destroy
    end

    redirect_to cats_url
  end

  private
  def session_params
    params.require(:user).permit(:username, :password)
  end
end
