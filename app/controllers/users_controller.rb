class UsersController < ApplicationController
  before_action :redirect_home_if_signed_in, only: [:new, :create]

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
end
