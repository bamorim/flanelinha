class AccountsController < ApplicationController
  def create
    Account.transaction do
      @acc = Account.new(account_params)
      @acc.save!
      @car = @acc.cars.new(car_params)
      @car.save!
      render json: @acc, status: :created
    end
  rescue => e
    if @acc && !@acc.valid?
      render json: @acc.errors, status: :unprocessable_entity
    elsif @car && !@car.valid?
      render json: @car.errors, status: :unprocessable_entity
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:email, :document_number, :disabled)
  end

  def car_params
    params.require(:car).permit(:plate_number, :nickname)
  end
end
