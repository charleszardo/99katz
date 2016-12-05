class CatRentalRequestsController < ApplicationController
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all

    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    cat = Cat.find(request_params['cat_id'])

    if @request.save
      redirect_to cat_url(cat)
    else
      flash.now[:errors] = @request.errors.full_messages
      render :new
    end
  end

  private
  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
