# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

# Team creation
teams = [
  { city: "Arizona", name: "Cardinals", abbr: "ARI" },
  { city: "Atlanta", name: "Falcons", abbr: "ATL" },
  { city: "Baltimore", name: "Ravens", abbr: "BAL" },
  { city: "Buffalo", name: "Bills", abbr: "BUF" },
  { city: "Carolina", name: "Panthers", abbr: "CAR" },
  { city: "Chicago", name: "Bears", abbr: "CHI" },
  { city: "Cincinnati", name: "Bengals", abbr: "CIN" },
  { city: "Cleveland", name: "Browns", abbr: "CLE" },
  { city: "Dallas", name: "Cowboys", abbr: "DAL" },
  { city: "Denver", name: "Broncos", abbr: "DEN" },
  { city: "Detroit", name: "Lions", abbr: "DET" },
  { city: "Green Bay", name: "Packers", abbr: "GB" },
  { city: "Houston", name: "Texans", abbr: "HOU" },
  { city: "Indianapolis", name: "Colts", abbr: "IND" },
  { city: "Jacksonville", name: "Jaguars", abbr: "JAC" },
  { city: "Kansas City", name: "Chiefs", abbr: "KC" },
  { city: "Miami", name: "Dolphins", abbr: "MIA" },
  { city: "Minnesota", name: "Vikings", abbr: "MIN" },
  { city: "New England", name: "Patriots", abbr: "NE" },
  { city: "New Orleans", name: "Saints", abbr: "NO" },
  { city: "New York", name: "Giants", abbr: "NYG" },
  { city: "New York", name: "Jets", abbr: "NYJ" },
  { city: "Oakland", name: "Raiders", abbr: "OAK" },
  { city: "Philadelphia", name: "Eagles", abbr: "PHI" },
  { city: "Pittsburgh", name: "Steelers", abbr: "PIT" },
  { city: "San Diego", name: "Chargers", abbr: "SD" },
  { city: "Seattle", name: "Seahawks", abbr: "SEA" },
  { city: "San Francisco", name: "49ers", abbr: "SF" },
  { city: "St. Louis", name: "Rams", abbr: "STL" },
  { city: "Tampa Bay", name: "Buccaneers", abbr: "TB" },
  { city: "Tennessee", name: "Titans", abbr: "TEN" },
  { city: "Washington", name: "Redskins", abbr: "WAS" }
]
teams.each{ |team|
  Team.create!(
    name: team[:name],
    city: team[:city],
    abbr: team[:abbr],
    logo: File.new("#{Rails.root}/public/TEMP/nfl/#{team[:abbr].downcase}.png")
  )
}

# Add some users and groups
User.create!(
  first_name: "Andy", last_name: "dePasquale", handle: "webakimbo", display_name_as: "full_name", 
  location: "San Francisco, CA", avatar: File.new("#{Rails.root}/public/TEMP/hs_icon.jpg"), 
  email: "andy@coderefactory.com", password: "password", password_confirmation: "password", show_location: true, show_email: true, active: true
)
User.create!(
  first_name: "Trey", last_name: "Anastasio", handle: "crimson_dago", display_name_as: "handle", 
  location: "Burlington, VT", avatar: File.new("#{Rails.root}/public/TEMP/trey.jpg"), 
  email: "nfl1@webakimbo.com", password: "password", password_confirmation: "password", show_location: true, show_email: true, active: true
)
User.create!(
  first_name: "Jimi", last_name: "Hendrix", handle: "experienced", display_name_as: "full_name", 
  location: "Michigan", avatar: File.new("#{Rails.root}/public/TEMP/jimi.jpg"), 
  email: "nfl2@webakimbo.com", password: "password", password_confirmation: "password", show_location: true, show_email: true, active: true
)
User.create!(
  first_name: "Bill", last_name: "Burr", handle: "ginger_comedian", display_name_as: "handle", 
  location: "Boston, MA", avatar: File.new("#{Rails.root}/public/TEMP/bill_burr.jpg"), 
  email: "nfl3@webakimbo.com", password: "password", password_confirmation: "password", show_location: true, show_email: true, active: true
)

Group.create!(
  name: "There Can Be Only One", tagline: "We love Highlander quotes", active: true, users: User.all
)

# Seasons
Season.create!(
  year: "2015", current: true
)

# Competitions
Competition.create!(
  # group_id: 1, season_id: 1, buyin: 10.00, users: User.all
  group_id: 1, season_id: 1, buyin: 10.00
)

# Weeks; Matchups; Picks
week1_deadline  = Time.utc(2015, 9, 11, 1, 25, 0) # Thurs, 8:25pm EST
deadline        = week1_deadline.to_s.to_datetime.strftime('%Q').to_i
week1_ends      = Time.utc(2015, 9, 15, 11, 0, 0) # Tues, 6:00am EST
ends            = week1_ends.to_s.to_datetime.strftime('%Q').to_i
17.times do |i|
  # Create all weeks
  dl = (deadline + (1000 * 60 * 60 * 24 * 7 * i)) / 1000
  e  = (ends + (1000 * 60 * 60 * 24 * 7 * i)) / 1000
  week = Week.create!(
    name: "Week #{i+1}", season_id: 1, deadline: Time.at(dl), ends: Time.at(e)
  )

  # If week is past, generate some phony matchups and results
  unless Time.at(e).future?
    shuffled = Team.all.map{ |team| team.full_name }.shuffle
    matchup_count = shuffled.count/2
    matchups_split = shuffled.each_slice(matchup_count).to_a
    matchup_ids = []
    matchup_count.times do |m|
      home_score = rand(60)
      away_score = rand(60)
      matchup = Matchup.create!(
        event_id: ('a'..'z').to_a.shuffle[0,18].join, week_id: week.id, 
        home_team: matchups_split[0][m], away_team: matchups_split[1][m], 
        match_time: Time.at(dl + (60 * 5)), 
        home_score: home_score, away_score: away_score, home_won: (home_score >= away_score), is_final: true
      )
      matchup_ids << matchup.id
    end

    # And generate some phony picks for each participant
    4.times do |j|
      random_matchup = Matchup.find(matchup_ids.sample)
      picked_home_team = [true, false][rand(2)]
      point_value_win = (100 + rand(800))
      point_value_lose = (100 + rand(800))
      pick_correct = ((picked_home_team and random_matchup.home_won) or (!picked_home_team and !random_matchup.home_won))
      Pick.create!(
        user_id: (j + 1), competition_id: 1, matchup_id: random_matchup.id, 
        picked_home_team: picked_home_team, point_value_win: point_value_win, point_value_lose: point_value_lose, 
        pick_correct: pick_correct, points_awarded: (pick_correct ? point_value_win : -point_value_lose)
      )
    end
  end
end

# Create an unattached user
User.create!(
  first_name: "Eli", last_name: "Manning", handle: "lesser_manning", display_name_as: "full_name", 
  location: "Vicksburg, MS", avatar: File.new("#{Rails.root}/public/TEMP/eli_manning.jpg"), 
  email: "nfl4@webakimbo.com", password: "password", password_confirmation: "password", show_location: true, show_email: true, active: true
)

# # Picks
# 4.times do |j|
#   8.times do |i|
#     tms       = teams.clone
#     pick      = tms.delete_at(rand(tms.count))
#     opponent  = tms.delete_at(rand(tms.count))
#     odds      = 1 + rand(9)
#     favorite  = [pick, opponent][rand(2)]
#     correct   = [true, false][rand(2)]

#     Pick.create!(
#       user_id: (j + 1), week_id: (i + 1), competition_id: 1, 
#       team_id: Team.where(abbr: pick[:abbr]).first.id, 
#       opponent_id: Team.where(abbr: opponent[:abbr]).first.id, 
#       favorite_id: Team.where(abbr: favorite[:abbr]).first.id, 
#       odds: odds, point_value: odds, pick_correct: correct, points_awarded: (correct ? odds : -odds)
#     )
#   end
# end


# create_table :matchups do |t|
#   t.string    :event_id
#   t.integer   :week_id
#   t.string    :home_team
#   t.string    :away_team
#   t.datetime  :match_time
#   t.integer   :home_score
#   t.integer   :away_score
#   t.boolean   :home_won
#   t.boolean   :is_final
# end

# create_table :picks do |t|
#   t.integer   :user_id
#   t.integer   :competition_id
#   t.integer   :matchup_id
#   t.boolean   :picked_home_team
#   t.integer   :point_value_win
#   t.integer   :point_value_lose
#   t.boolean   :pick_correct
#   t.integer   :points_awarded
#   t.timestamps null: false
# end












