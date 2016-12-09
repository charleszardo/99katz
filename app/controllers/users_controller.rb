class UsersController < ApplicationController
  before_action :disallow_if_signed_in, only: [:new, :create]
  before_action :only_user_can_see_own_profile, only: [:show]

  def new
    @signin_page = true
    @user = User.new

    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login_user!(@user)
      redirect_to cats_url
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
