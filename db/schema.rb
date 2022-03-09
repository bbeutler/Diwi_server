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

ActiveRecord::Schema.define(version: 2021_12_08_091349) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "consumers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "consumer_id"
    t.string "device_token", limit: 255, null: false
    t.boolean "enabled", default: true, null: false
    t.integer "platform", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_id"], name: "index_devices_on_consumer_id"
  end

  create_table "look_tags", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "look_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["look_id"], name: "index_look_tags_on_look_id"
    t.index ["tag_id"], name: "index_look_tags_on_tag_id"
  end

  create_table "looks", force: :cascade do |t|
    t.string "title"
    t.string "note"
    t.date "dates_worn", default: [], array: true
    t.bigint "consumer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.index ["consumer_id"], name: "index_looks_on_consumer_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "image"
    t.bigint "look_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["look_id"], name: "index_photos_on_look_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.bigint "subscription_id"
    t.string "transaction_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_receipts_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "consumer_id"
    t.integer "method_of_payment", null: false
    t.string "product_id", null: false
    t.string "product_name", null: false
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_id"], name: "index_subscriptions_on_consumer_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "consumer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_id"], name: "index_tags_on_consumer_id"
  end

  create_table "terms_acceptances", force: :cascade do |t|
    t.datetime "accepted_at"
    t.bigint "consumer_id"
    t.string "remote_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_id"], name: "index_terms_acceptances_on_consumer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_type"
    t.bigint "profile_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["profile_type", "profile_id"], name: "index_users_on_profile_type_and_profile_id"
  end

  create_table "videos", force: :cascade do |t|
    t.integer "look_id"
    t.string "video"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "devices", "consumers"
  add_foreign_key "look_tags", "looks"
  add_foreign_key "look_tags", "tags"
  add_foreign_key "looks", "consumers"
  add_foreign_key "photos", "looks"
  add_foreign_key "receipts", "subscriptions"
  add_foreign_key "subscriptions", "consumers"
  add_foreign_key "tags", "consumers"
  add_foreign_key "terms_acceptances", "consumers"
end
