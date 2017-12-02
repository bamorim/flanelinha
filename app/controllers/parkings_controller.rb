class ParkingsController < ApplicationController
  # GET /parkings
  def index
    @parkings = Parking.all

    render json: @parkings
  end
end
