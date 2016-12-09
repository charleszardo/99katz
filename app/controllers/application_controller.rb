class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_session

  def current_user
    @current_user = current_session.user if current_session
  end

  def current_session
    Session.includes(:user).find_by(session_token: session[:session_token])
  end

  def login_user!(user)
    token = Session.generate_session_token
    device_type = request.env['mobvious.device_type'].to_s
    curr_session = Session.new(user: user, session_token: token, device_type: device_type)
    if curr_session.save
      session[:session_token] = token
    else
      render json: session.errors.full_messages
    end
  end

  private
  def disallow_if_signed_in
    redirect_back if current_user
  end

  def redirect_back
    loc = request.referer.nil? ? cats_url : request.referer
    session[:return_to] ||= loc
    redirect_to session.delete(:return_to)
  end

  def require_login
    redirect_back unless current_user
  end
end
