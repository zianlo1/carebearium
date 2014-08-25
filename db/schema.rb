# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140824150302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: true do |t|
    t.integer "corporation_id"
    t.integer "station_id"
    t.integer "solar_system_id"
    t.integer "level"
    t.string  "kind"
    t.boolean "locator"
  end

  create_table "corporations", force: true do |t|
    t.string  "name"
    t.integer "agents_count", default: 0
  end

  create_table "solar_systems", force: true do |t|
    t.string   "name"
    t.string   "region_name"
    t.float    "security"
    t.integer  "belt_count"
    t.integer  "agents_count",   default: 0
    t.integer  "stations_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stations", force: true do |t|
    t.string  "name"
    t.integer "solar_system_id"
    t.integer "agents_count",    default: 0
  end

end
