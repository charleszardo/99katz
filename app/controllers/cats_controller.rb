class CatsController < ApplicationController
  before_action :require_user_owns_cat, only: [:edit, :update]
  before_action :set_gender_and_colors, only: [:new, :edit]
  before_action :require_login, only: [:new, :create, :edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @requests = @cat.cat_rental_requests
    @users_cat = user_owns_cat?

    render :show
  end

  def new
    @cat = Cat.new

    render :new
  end

  def create
    @cat = current_user.cats.new(cat_params)

    if @cat.save!
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find(params[:id])

    render :edit
  end

  def update
    @cat = current_user.cats.find(params[:id])

    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:erros] = @cat.errors.full_messages
      render :edit
    end
  end

  private
  def cat_params
    params.require(:cat).permit(:birth_date, :color, :name, :sex, :description)
  end

  def set_gender_and_colors
    @genders = Cat.get_genders
    @colors = Cat.get_colors
  end

  def user_owns_cat?
    current_user && current_user.owns_cat?(params[:id])
  end

  def require_user_owns_cat
    unless user_owns_cat?
      redirect_to cats_url
    end
  end
end
