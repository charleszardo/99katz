class SessionsController < ApplicationController
  def new
    @session = Session.new

    render :new
  end

  def create
  end

  def destroy

  end
end
