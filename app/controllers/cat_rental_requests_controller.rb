class CatRentalRequestsController < ApplicationController
  before_action :only_owner_can_approve_request, only: [:approve, :deny]
  before_action :request_must_be_made_by_user, only: [:new, :create]

  def new
    @request = CatRentalRequest.new
    @cats = Cat.all

    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    @request.requester = current_user
    cat = Cat.find(request_params['cat_id'])

    if @request.save
      redirect_to cat_url(cat)
    else
      flash[:errors] = @request.errors.full_messages
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
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

  def change_status(new_status)
    @request = CatRentalRequest.find(params[:id])

    if @request.pending?
      @request.send("#{new_status}!")
    else
      flash.now[:errors] = @request.errors.full_messages
    end

    redirect_to :back
  end

  def only_owner_can_approve_request
    request = CatRentalRequest.find(params[:id])
    unless current_user && current_user.owns_cat?(request.cat_id)
      redirect_to cat_url(request.cat_id)
    end
  end

  def request_must_be_made_by_user
    unless current_user
      flash.now[:errors] = "You must be logged in to make a request"
      render :new
    end
  end
end
