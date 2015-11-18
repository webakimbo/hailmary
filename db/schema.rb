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

ActiveRecord::Schema.define(version: 20151117221350) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "competitions", force: :cascade do |t|
    t.integer "group_id"
    t.integer "season_id"
    t.decimal "buyin",     precision: 2
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "tagline"
    t.string   "avatar"
    t.integer  "administrator_user_id"
    t.boolean  "active"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "week_id"
    t.integer  "competition_id"
    t.integer  "team_id"
    t.integer  "opponent_id"
    t.integer  "favorite_id"
    t.string   "odds"
    t.integer  "point_value"
    t.boolean  "pick_correct"
    t.integer  "points_awarded"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "year"
    t.boolean "current"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "city"
    t.string   "logo"
    t.boolean  "active"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "handle"
    t.string   "location"
    t.string   "avatar"
    t.string   "display_name_as"
    t.string   "email"
    t.string   "password"
    t.boolean  "show_location"
    t.boolean  "show_email"
    t.boolean  "active"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "weeks", force: :cascade do |t|
    t.string   "name"
    t.integer  "season_id"
    t.datetime "deadline"
    t.datetime "ends"
  end

end
