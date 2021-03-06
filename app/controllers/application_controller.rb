class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :current_session
  helper_method :logged_in?

  private
  def current_user
    @current_user ||= current_session.user if current_session
  end

  def current_session
    @current_session ||= Session.includes(:user).find_by(session_token: session[:session_token])
  end

  def login_user!(user)
    token = Session.generate_session_token
    device_type = request.env['mobvious.device_type'].to_s
    loc = request.location.data["city"]
    curr_session = Session.new(user: user,
                               session_token: token,
                               device_type: device_type,
                               location: loc)
    if curr_session.save
      session[:session_token] = token
    else
      render json: session.errors.full_messages
    end
  end

  def require_no_user
    redirect_to cats_url if current_user
  end

  def set_redirect_back
    loc = request.referer.nil? ? cats_url : request.referer
    session[:return_to] ||= loc
  end

  def redirect_back
    redirect_to session.delete(:return_to)
  end

  def require_user
    redirect_to cats_url unless current_user
  end

  def logged_in?
    !current_user.nil?
  end
end
