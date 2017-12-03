# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171203111048) do

  create_table "accounts", force: :cascade do |t|
    t.string "email"
    t.string "password_hash"
    t.string "document_number"
    t.string "document_type"
    t.boolean "disabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "cards", force: :cascade do |t|
    t.string "last_digits"
    t.integer "valid_year"
    t.integer "valid_month"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_cards_on_account_id"
  end

  create_table "cars", force: :cascade do |t|
    t.integer "account_id"
    t.string "plate_number"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_cars_on_account_id"
  end

  create_table "parkings", force: :cascade do |t|
    t.string "name"
    t.integer "spaces", default: 0
    t.integer "disabled_spaces", default: 0
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.integer "car_id"
    t.float "destination_longitude"
    t.float "destination_latitude"
    t.integer "parking_id"
    t.datetime "reserved_at"
    t.datetime "parked_at"
    t.datetime "unparked_at"
    t.datetime "cancelled_at"
    t.integer "reserved_duration"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_trips_on_car_id"
    t.index ["parking_id"], name: "index_trips_on_parking_id"
  end

end
