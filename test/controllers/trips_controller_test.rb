require 'test_helper'

class TripsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trip = trips(:one)
  end

  test "should create trip" do
    assert_difference('Trip.count') do
      post trips_url, params: { trip: { car_id: @trip.car_id, destination_latitude: @trip.destination_latitude, destination_longitude: @trip.destination_longitude } }, as: :json
    end

    assert Trip.last.planned?
    assert_response 201
  end

  test "should show trip" do
    get trip_url(@trip), as: :json
    assert_response :success
  end
end
