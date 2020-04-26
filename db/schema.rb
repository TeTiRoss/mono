# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_25_131240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currency_rates", force: :cascade do |t|
    t.jsonb "raw_data"
    t.integer "date_int"
    t.string "iso_nummeric_from"
    t.string "iso_nummeric_to"
    t.decimal "rate_buy", precision: 13, scale: 4
    t.decimal "rate_sell", precision: 13, scale: 4
    t.decimal "rate_cross", precision: 13, scale: 4
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.jsonb "raw_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "mono_id"
    t.index ["mono_id"], name: "index_transactions_on_mono_id", unique: true
  end

end
