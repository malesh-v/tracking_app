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

ActiveRecord::Schema.define(version: 2018_07_09_090238) do

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_clients_on_email", unique: true
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_departments_on_name", unique: true
  end

  create_table "staff_members", force: :cascade do |t|
    t.string "login"
    t.string "password_digest"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token"
    t.index ["login"], name: "index_staff_members_on_login", unique: true
    t.index ["remember_token"], name: "index_staff_members_on_remember_token"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_statuses_on_name", unique: true
  end

  create_table "tickets", force: :cascade do |t|
    t.string "subject"
    t.string "content"
    t.string "uniques_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_id"
    t.index ["uniques_code"], name: "index_tickets_on_uniques_code", unique: true
  end

end
