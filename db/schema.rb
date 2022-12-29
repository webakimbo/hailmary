# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_12_27_195934) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matchup_teams", force: :cascade do |t|
    t.bigint "matchup_id"
    t.bigint "team_id"
    t.boolean "home", default: false
    t.integer "score", default: 0
    t.boolean "won", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matchup_id"], name: "index_matchup_teams_on_matchup_id"
    t.index ["team_id"], name: "index_matchup_teams_on_team_id"
  end

  create_table "matchups", force: :cascade do |t|
    t.bigint "week_id"
    t.datetime "kickoff"
    t.string "location"
    t.boolean "final", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["week_id"], name: "index_matchups_on_week_id"
  end

  create_table "picks", force: :cascade do |t|
    t.bigint "user_season_id"
    t.bigint "week_id"
    t.bigint "team_id"
    t.decimal "odds", precision: 6, scale: 5, default: "0.5"
    t.boolean "correct", default: false
    t.integer "points", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_picks_on_team_id"
    t.index ["user_season_id"], name: "index_picks_on_user_season_id"
    t.index ["week_id"], name: "index_picks_on_week_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.string "name"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sim_matchup_teams", force: :cascade do |t|
    t.bigint "sim_matchup_id"
    t.bigint "team_id"
    t.decimal "strength", precision: 6, scale: 5, default: "0.5"
    t.boolean "home", default: false
    t.integer "score", default: 0
    t.boolean "won", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sim_matchup_id"], name: "index_sim_matchup_teams_on_sim_matchup_id"
    t.index ["team_id"], name: "index_sim_matchup_teams_on_team_id"
  end

  create_table "sim_matchups", force: :cascade do |t|
    t.bigint "week_id"
    t.datetime "kickoff"
    t.string "location"
    t.boolean "final", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["week_id"], name: "index_sim_matchups_on_week_id"
  end

  create_table "sim_picks", force: :cascade do |t|
    t.bigint "sim_user_season_id"
    t.bigint "week_id"
    t.bigint "team_id"
    t.decimal "odds", precision: 6, scale: 5, default: "0.5"
    t.boolean "correct", default: false
    t.integer "points", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sim_user_season_id"], name: "index_sim_picks_on_sim_user_season_id"
    t.index ["team_id"], name: "index_sim_picks_on_team_id"
    t.index ["week_id"], name: "index_sim_picks_on_week_id"
  end

  create_table "sim_user_seasons", force: :cascade do |t|
    t.bigint "sim_user_id"
    t.bigint "season_id"
    t.integer "points", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_sim_user_seasons_on_season_id"
    t.index ["sim_user_id"], name: "index_sim_user_seasons_on_sim_user_id"
  end

  create_table "sim_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "text"
    t.string "contact_preference", default: "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "city"
    t.string "name"
    t.string "abbr"
    t.string "conference"
    t.string "division"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_seasons", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "season_id"
    t.integer "points", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_user_seasons_on_season_id"
    t.index ["user_id"], name: "index_user_seasons_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "text"
    t.string "contact_preference", default: "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weeks", force: :cascade do |t|
    t.integer "week"
    t.bigint "season_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_weeks_on_season_id"
  end

end
