class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @requests = @cat.cat_rental_requests

    render :show
  end

  def new
    @cat = Cat.new
    set_gender_and_colors

    render :new
  end

  def create
    @cat = Cat.new(cat_params)

    if @cat.save!
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    set_gender_and_colors

    render :edit
  end

  def update
    @cat = Cat.find(params[:id])

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
end
