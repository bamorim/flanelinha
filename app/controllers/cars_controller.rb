class CarsController < ApplicationController
  # GET /cars
  def index
    @cars = account.cars

    render json: @cars
  end

  # POST /cars
  def create
    @car = account.cars.new(car_params)

    if @car.save
      render json: @car, status: :created, location: @car
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cars/1
  def update
    @car = account.cars.find(params[:id])

    if @car.update(car_params)
      render json: @car
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def car_params
      params.require(:car).permit(:plate_number, :nickname)
    end
end
