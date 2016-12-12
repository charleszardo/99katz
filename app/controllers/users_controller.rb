class UsersController < ApplicationController
  before_action :require_no_user, only: [:new, :create]
  before_action :only_user_can_see_own_profile, only: [:show]

  def new
    @signin_page = true
    @user = User.new

    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      msg = UserMailer.welcome_email(@user)
      msg.deliver
      login_user!(@user)
      redirect_back
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:id])

    render :show
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end

  def only_user_can_see_own_profile
    redirect_back unless current_user && current_user.id == params[:id].to_i
  end
end
