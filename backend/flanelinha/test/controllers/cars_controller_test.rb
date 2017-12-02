require 'test_helper'

class CarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car = cars(:one)
  end

  test "should get index" do
    get cars_url, as: :json
    assert_response :success
  end

  test "should create car" do
    assert_difference('Car.count') do
      post cars_url, params: { car: { nickname: @car.nickname, plate_number: @car.plate_number } }, as: :json
    end

    assert_response 201
  end

  test "should update car" do
    patch car_url(@car), params: { car: { nickname: @car.nickname, plate_number: @car.plate_number } }, as: :json
    assert_response 200
  end
end
