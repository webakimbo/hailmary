require 'csv'
require 'faker'

# TEAMS
teams = [
  { city: "Arizona", name: "Cardinals", abbr: "ARI", conference: "NFC", division: "West" },
  { city: "Atlanta", name: "Falcons", abbr: "ATL", conference: "NFC", division: "South" },
  { city: "Baltimore", name: "Ravens", abbr: "BAL", conference: "AFC", division: "North" },
  { city: "Buffalo", name: "Bills", abbr: "BUF", conference: "AFC", division: "East" },
  { city: "Carolina", name: "Panthers", abbr: "CAR", conference: "NFC", division: "South" },
  { city: "Chicago", name: "Bears", abbr: "CHI", conference: "NFC", division: "North" },
  { city: "Cincinnati", name: "Bengals", abbr: "CIN", conference: "AFC", division: "North" },
  { city: "Cleveland", name: "Browns", abbr: "CLE", conference: "AFC", division: "North" },
  { city: "Dallas", name: "Cowboys", abbr: "DAL", conference: "NFC", division: "East" },
  { city: "Denver", name: "Broncos", abbr: "DEN", conference: "AFC", division: "West" },
  { city: "Detroit", name: "Lions", abbr: "DET", conference: "NFC", division: "North" },
  { city: "Green Bay", name: "Packers", abbr: "GB", conference: "NFC", division: "North" },
  { city: "Houston", name: "Texans", abbr: "HOU", conference: "AFC", division: "South" },
  { city: "Indianapolis", name: "Colts", abbr: "IND", conference: "AFC", division: "South" },
  { city: "Jacksonville", name: "Jaguars", abbr: "JAC", conference: "AFC", division: "South" },
  { city: "Kansas City", name: "Chiefs", abbr: "KC", conference: "AFC", division: "West" },
  { city: "Las Vegas", name: "Raiders", abbr: "LV", conference: "AFC", division: "West" },
  { city: "Los Angeles", name: "Chargers", abbr: "LAC", conference: "AFC", division: "West" },
  { city: "Los Angeles", name: "Rams", abbr: "LAR", conference: "NFC", division: "West" },
  { city: "Miami", name: "Dolphins", abbr: "MIA", conference: "AFC", division: "East" },
  { city: "Minnesota", name: "Vikings", abbr: "MIN", conference: "NFC", division: "North" },
  { city: "New England", name: "Patriots", abbr: "NE", conference: "AFC", division: "East" },
  { city: "New Orleans", name: "Saints", abbr: "NO", conference: "NFC", division: "South" },
  { city: "New York", name: "Giants", abbr: "NYG", conference: "NFC", division: "East" },
  { city: "New York", name: "Jets", abbr: "NYJ", conference: "AFC", division: "East" },
  { city: "Philadelphia", name: "Eagles", abbr: "PHI", conference: "NFC", division: "East" },
  { city: "Pittsburgh", name: "Steelers", abbr: "PIT", conference: "AFC", division: "North" },
  { city: "San Francisco", name: "49ers", abbr: "SF", conference: "NFC", division: "West" },
  { city: "Seattle", name: "Seahawks", abbr: "SEA", conference: "NFC", division: "West" },
  { city: "Tampa Bay", name: "Buccaneers", abbr: "TB", conference: "NFC", division: "South" },
  { city: "Tennessee", name: "Titans", abbr: "TEN", conference: "AFC", division: "South" },
  { city: "Washington", name: "Commanders", abbr: "WSH", conference: "NFC", division: "East" },
]
teams.each do |team|
  Team.find_or_create_by(team)
end


# SEASONS & WEEKS
# use real data
season_name = "2022-3"
seasons = [
  {
    name: season_name,
    start: DateTime.parse("July 1, 2022"),
    end: DateTime.parse("June 30, 2023"),
    week_dates: [
      ["August 29, 2022", "September 12, 2022"],
      ["September 13, 2022", "September 19, 2022"],
      ["September 20, 2022", "September 26, 2022"],
      ["September 27, 2022", "October 3, 2022"],
      ["October 4, 2022", "October 10, 2022"],
      ["October 11, 2022", "October 17, 2022"],
      ["October 18, 2022", "October 24, 2022"],
      ["October 25, 2022", "October 31, 2022"],
      ["November 1, 2022", "November 7, 2022"],
      ["November 8, 2022", "November 14, 2022"],
      ["November 15, 2022", "November 21, 2022"],
      ["November 22, 2022", "November 28, 2022"],
      ["November 29, 2022", "December 5, 2022"],
      ["December 6, 2022", "December 12, 2022"],
      ["December 13, 2022", "December 19, 2022"],
      ["December 20, 2022", "December 26, 2022"],
      ["December 27, 2022", "January 2, 2023"],
      ["January 3, 2023", "January 8, 2023"],
    ]
  },
]
seasons.each do |season|
  s = Season.find_or_create_by(season.except(:week_dates))
  season[:week_dates].each_with_index do |w, i|
    week = {
      week: i + 1,
      season: s,
      start: DateTime.parse(w[0]),
      end: DateTime.parse(w[1]),
    }
    Week.find_or_create_by(week)
  end
end


# MATCHUPS
# real and simulated will both use real data
#  - import schedule for 2022-3 season
schedule_path = Rails.root.join("lib", "seeds", "NFL 2022-2023 Schedule 2.tsv")
schedule = CSV.read(schedule_path, col_sep: "|")
#  - get season/weeks/teams db records
first_season = Season.find_by_name(season_name)
weeks_map = first_season.weeks.map{|w| [w.week.to_s, w]}.to_h
teams_map = Team.all.map{|t| [t.full_name, t]}.to_h
#  - populate
schedule.each do |game|
  # destructure for clarity
  week_number, kickoff, away_team, home_team, location = game
  # matchup / simulated matchup
  matchup = {
    week: weeks_map[week_number],
    kickoff: kickoff,
    location: location,
  }
  m = Matchup.find_or_create_by(matchup)
  sm = SimMatchup.find_or_create_by(matchup)
  # away matchup_team / simulated away matchup_team
  MatchupTeam.find_or_create_by({ matchup: m, team: teams_map[away_team] })
  SimMatchupTeam.find_or_create_by({ sim_matchup: sm, team: teams_map[away_team] })
  # home matchup_team / simulated home matchup_team
  MatchupTeam.find_or_create_by({ matchup: m, team: teams_map[home_team], home: true })
  SimMatchupTeam.find_or_create_by({ sim_matchup: sm, team: teams_map[home_team], home: true })
end


# SIMULATED USERS & USER SEASONS
SimUser.destroy_all
SimUserSeason.destroy_all
sim_users = Array.new(10).map do |i|
  {
    first_name: Faker::Name.unique.first_name,
    last_name: Faker::Name.unique.last_name,
    email: Faker::Internet.safe_email,
    text: Faker::Number.number(digits: 10),
  }
end
sim_users.each do |sim_user|
  su = SimUser.create!(sim_user)
  SimUserSeason.create!(sim_user: su, season: first_season)
end
Faker::Name.unique.clear


