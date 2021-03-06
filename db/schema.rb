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

ActiveRecord::Schema.define(version: 20150209015005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "users", primary_key: "uuid", force: true do |t|
    t.text "email",         null: false
    t.text "name",          null: false
    t.text "access_token",  null: false
    t.text "refresh_token", null: false
  end

  add_index "users", ["access_token"], name: "users_access_token_key", unique: true, using: :btree
  add_index "users", ["email"], name: "users_email_key", unique: true, using: :btree
  add_index "users", ["name"], name: "users_name_key", unique: true, using: :btree
  add_index "users", ["refresh_token"], name: "users_refresh_token_key", unique: true, using: :btree

end
