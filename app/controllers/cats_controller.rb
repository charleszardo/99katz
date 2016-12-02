class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])

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
      flash.now[:errors] =@cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    set_gender_and_colors
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
