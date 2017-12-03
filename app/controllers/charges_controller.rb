class ChargesController < ApplicationController
  def index
    trips = account.trips.where(
      state: :unparked,
    ).where.not(
      parking_id: nil
    )

    charges = trips.map do |t|
      start_dt = t.parked_at.to_datetime
      end_dt = t.unparked_at.to_datetime
      year = start_dt.year.to_s.last(2)
      date =  "%02d/%02d/%02d" % [start_dt.day, start_dt.month, year]
      start_h = "%02d:%02d" % [start_dt.hour, start_dt.minute]
      end_h = "%02d:%02d" % [end_dt.hour, end_dt.minute]
      {
        parking_name: t.parking.name,
        date: date,
        start_hour: start_h,
        end_hour: end_h
      }
    end

    render json: charges
  end
end
