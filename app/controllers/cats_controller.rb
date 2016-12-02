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
    @genders = Cat.get_genders
    @colors = Cat.get_colors

    render :new
  end

  private
  def cats_params
    params.require(:cats).permit(:birth_date, :color, :name, :sex, :description)
  end
end
