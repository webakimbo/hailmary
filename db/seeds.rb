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
  email: "andy@coderefactory.com", password: "password", show_location: true, show_email: true, active: true
)
User.create!(
  first_name: "Trey", last_name: "Anastasio", handle: "crimson_dago", display_name_as: "handle", 
  location: "Burlington, VT", avatar: File.new("#{Rails.root}/public/TEMP/trey.jpg"), 
  email: "nfl1@webakimbo.com", password: "password", show_location: true, show_email: true, active: true
)

Group.create!(
  name: "Experimental NFL Pool", tagline: "Let's see what happens", active: true, users: User.all
)

# Seasons
Season.create!(
  year: "2015", current: true
)

# Weeks
week1_deadline = Time.utc(2015, 9, 11, 1, 25, 0)
deadline = week1_deadline.to_s.to_datetime.strftime('%Q').to_i
17.times do |i|
  dl = deadline + (1000 * 60 * 60 * 24 * 7 * i)
  Week.create!(
    week: "Week #{i+1}", season_id: 1, deadline: Time.at(dl/1000)
  )
end

# Competitions
Competition.create!(
  group_id: 1, season_id: 1, buyin: 10.00, users: User.all
)

# Create an unattached user
User.create!(
  first_name: "Eli", last_name: "Manning", handle: "lesser_manning", display_name_as: "full_name", 
  location: "Vicksburg, MS", avatar: File.new("#{Rails.root}/public/TEMP/eli_manning.jpg"), 
  email: "nfl2@webakimbo.com", password: "password", show_location: true, show_email: true, active: true
)

# Picks
2.times do |j|
  8.times do |i|
    # t.integer   :user_id
    # t.integer   :week_id
    # t.integer   :team_id
    # t.integer   :opponent_id
    # t.integer   :favorite_id
    # t.string    :odds
    # t.integer   :point_value
    # t.boolean   :pick_correct
    # t.integer   :points_awarded

    tms       = teams.clone
    pick      = tms.delete_at(rand(tms.count))
    opponent  = tms.delete_at(rand(tms.count))
    odds      = 1 + rand(9)
    favorite  = [pick, opponent][rand(2)]
    correct   = [true, false][rand(2)]

    Pick.create!(
      user_id: (j + 1), week_id: (i + 1), competition_id: 1, 
      team_id: Team.where(abbr: pick[:abbr]).first.id, 
      opponent_id: Team.where(abbr: opponent[:abbr]).first.id, 
      favorite_id: Team.where(abbr: favorite[:abbr]).first.id, 
      odds: odds, point_value: odds, pick_correct: correct, points_awarded: (correct ? odds : -odds)
    )
  end
end



