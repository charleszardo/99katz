class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user = nil
    if session
      current_session = Session.includes(:user).find_by(session_token: session[:session_token])
      if current_session
        @current_user = current_session.user
      end
    else
    end

    @current_user
  end

  def login_user!(user)
    token = Session.generate_session_token
    curr_session = Session.new(user: user, session_token: token)
    if curr_session.save
      session[:session_token] = token
      redirect_to cats_url
    else
      render json: session.errors.full_messages
    end
  end

  def redirect_home_if_signed_in
    redirect_to cats_url if current_user
  end
end
