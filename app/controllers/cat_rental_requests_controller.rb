class CatRentalRequestsController < ApplicationController
  before_action :require_cat_ownership, only: [:approve, :deny]
  before_action :require_user, only: [:new, :create]

  def new
    @request = CatRentalRequest.new
    @cats = Cat.all

    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    @request.requester = current_user

    if @request.save
      redirect_to cat_url(@request.cat)
    else
      flash.now[:errors] = @request.errors.full_messages
      redirect_to new_cat_rental_request_url
    end
  end

  def approve
    change_status("approve")
  end

  def deny
    change_status("deny")
  end

  private
  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end

  def current_cat_rental_request
    @request ||= CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def change_status(new_status)
    request = current_cat_rental_request

    if request.pending?
      request.send("#{new_status}!")
    else
      flash.now[:errors] = request.errors.full_messages
    end

    redirect_to :back
  end

  def require_cat_ownership
    request = current_cat_rental_request
    unless current_user && current_user.owns_cat?(current_cat)
      redirect_to cat_url(current_cat)
    end
  end
end
