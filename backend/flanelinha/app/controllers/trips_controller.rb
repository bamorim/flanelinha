class TripsController < ApplicationController
  def show
    @trip = account.trips.find(params[:id])

    render json: @trip
  end

  # POST /trips
  def create
    @trip = account.trips.new(trip_create_params)

    if @trip.save
      render json: @trip, status: :created, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def trip_create_params
      params.require(:trip).permit(:car_id, :destination_longitude, :destination_latitude)
    end
end
