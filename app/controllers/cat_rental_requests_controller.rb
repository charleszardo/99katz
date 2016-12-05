class CatRentalRequestsController < ApplicationController
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all

    render :new
  end
end
