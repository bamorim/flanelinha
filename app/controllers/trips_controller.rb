class TripsController < ApplicationController
  EVENTS = [
    :reserve,
    :park,
    :cancel,
    :unpark,
    :expire
  ]
  before_action :set_trip, only: EVENTS

  def show
    @trip = account.trips.find(params[:id])

    render json: @trip.to_json(:include => :parking)
  end

  # POST /trips
  def create
    @trip = account.trips.new(trip_create_params)

    if @trip.save
      render json: @trip.to_json(:include => :parking), status: :created, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  EVENTS.select{ |e| e != :park }.each do |e|
    define_method e do
      begin
        @trip.send(:"#{e}!")
        render json: @trip.to_json(:include => :parking)
      rescue
        render text: "", status: :unprocessable_entity
      end
    end
  end

  def park
    duration = params[:duration].to_i
    raise "invalid duration" unless duration > 0
    @trip.park!(duration)
    render json: @trip.to_json(:include => :parking)
  rescue
    render text: "", status: :unprocessable_entity
  end

  private
    def set_trip
      @trip = account.trips.find(params[:trip_id])
    end
    # Only allow a trusted parameter "white list" through.
    def trip_create_params
      defaults = {
        car_id: account.cars.first.try(:id)
      }

      defaults.merge(
        params.require(:trip).permit(:car_id, :destination_longitude, :destination_latitude)
      )
    end
end
