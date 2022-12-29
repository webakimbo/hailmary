module Simulation

  EVEN = 0.500

  MIN_CERTAINTY = 0.100
  MAX_CERTAINTY = 0.900

  WEIGHT_RECORD = 0.450
  WEIGHT_LAST_3 = 0.300
  WEIGHT_HOME   = 0.200
  WEIGHT_RANDOM = 0.050

  HOME_ADVANTAGE = 0.100

private

  def generate_strength(results, is_home)
    wins, losses = results.compact.partition{|win| win }
    last_3 = results.compact.last(3)
    home_advantage = is_home ? (EVEN + HOME_ADVANTAGE) : (EVEN - HOME_ADVANTAGE)

    weighted_record = win_pct(wins.size, losses.size) * WEIGHT_RECORD
    weighted_last_3 = last_3_pct(last_3) * WEIGHT_LAST_3
    weighted_home   = home_advantage * WEIGHT_HOME
    weighted_random = rand * WEIGHT_RANDOM

    strength = [
      weighted_record,
      weighted_last_3,
      weighted_home,
      weighted_random
    ].sum.clamp(MIN_CERTAINTY, MAX_CERTAINTY)

    [weighted_record, weighted_last_3, weighted_home, weighted_random, strength]
  end

  def win_pct(wins, losses)
    wins.to_f / (wins + losses).to_f
  end

  def last_3_pct(last_3)
    wins, losses = last_3.partition{|win| win }
    win_pct(wins.size, losses.size)
  end

  def mock_record
    Array.new(100).map{|i| rand > 0.5 }
  end

  def odds(team_strength, opponent_strength)
    EVEN + ((team_strength - opponent_strength) / 2)
  end

  def points(pick, opponent)
    if pick[:won]
      convert_points((opponent[:odds] / pick[:odds]))
    else
      convert_points((pick[:odds] / opponent[:odds]) * -1)
    end
  end

  def convert_points(float)
    (float * 100).round
  end

  def display_pts(pts)
    # pad to 6 chars including +/-
    show = pts.to_s.rjust(6)
    if pts > 0
      show.gsub!(/(\s)(\d)/, '+\2')
    end
    show
  end

  def printable_team(team)
    return nil unless team[:print]
    wins_before, losses_before = team[:results_before].compact.partition{|win| win }
    team[:team] = "#{team[:full_name]} (#{[wins_before.size, losses_before.size].join("-")})"
    team[:result] = team[:won] ? "W" : "L"
    # team.slice(:team, :results, :last3, :weighted_record, :weighted_last_3, :weighted_home, :weighted_random, :strength, :odds, :result)
    team.slice(:team, :results, :last3, :strength, :odds, :result)
  end

  def printable_pick(user_season)
    user_season.slice(:name, :picked, :change, :points)
  end

end


# SIMULATING ODDS AND RESULTS

# For each week, we need to:
#   1. mock odds for each matchup, based mostly on the teams' records to that point
#   2. randomly make picks for each user (no need to simulate a strategy)
#   3. simulate a game result
#   4. repeat

# 1. Odds

# Assign each team a strength coefficient for that week (in SIM_MATCHUP_TEAMS table). The goal is to convert this into odds of an outcome that are generally reflective of the team's strength, but not absolutely determinative. Limit upper and lower bounds to avoid absolute certainty of outcome - say, 10% to 90%.

# Factors for calculating a new strength coefficient each week might include:
#   - overall record
#   - record in most recent 3 games compared to overall record
#   - home vs away this week
#   - a dash of randomness

# Example:
#   condition                          coefficient       weight      
#   -------------                     -------------   -------------
#   record of 7-3                         .700            45%
#   last 3 results were 1-2               .333            30%
#   home this week, slight advantage      .600            20%
#   randomness                            .441             5%

#   .700 x 45 = 31.5
#   .333 x 30 =  9.99
#   .600 x 20 = 12
#   .441 x  5 =  2.205
#   ------------------
#               55.695 / 100 = .100 ≤ .55695 ≤ .900

# Prior to week 1, assign each team a strength coefficient according to a normal distribution. This generally comports with reality, and avoids divide-by-zero errors when calculating a 0-0 record.

# For weeks 2 and 3, last 3 results should just mean UP TO the last 3 results.

# The catch here is that, for any given matchup, the odds for the favorite must necessarily be the inverse for the underdog. But the above calculation doesn't automatically correlate opponents in this way.

# So we need to convert two strength coefficients into a single odds ratio for that matchup. Since we've decided to clamp the strength coefficients, conceptually we can divide the two. Max odds will be 9-to-1, min odds 1-to-9.

# Now we need to convert that single ratio to a value between .100 and .900 inclusive such that:
#   - a .100 team playing a .900 team will have .100 odds (minimum possible)
#   - a .100 team playing a .100 team will have .500 odds (even)
#   - a .100 team playing a .600 team will have .100 ≤ odds ≤ .500

# Simplest caluclation is .500 + ((ts - os)/2), where:
#   - ts = team strength coefficient
#   - os = opponent strength coefficient

# So a .100 team playing a .600 team will have .250 odds of winning, or 1-to-3.

# This will result in a favorite and an underdog (or, less commonly, two .500 teams) whose odds add up to exactly 1.

# 2. Picks

# For each user, pick a team they haven't previously picked this season. Odds for that team calculated in the first step.

# 3. Game Simulation

# Since each matchup now has odds expressed as a fraction, simulating a result is as simple as choosing a random float between 0 and 1, and comparing that float to EITHER the favorite or the underdog for all contests.
#   - if comparing to favorites, any float greater than the favorite's odds constitutes an upset
#   - if comparing to underdogs, any float less than the underdog's odds constitutes an upset

# Final score isn't important for simulations, but might look nicer in the UI. Here we just make up numbers, clamped between 0 and 50 (excluding 1), ensuring that the winner's total exceeds the loser's.

# 4. Repeat

# Repeat steps 1-3 for each week in the season. This should provide enough data to know if any of the parameters used in the above calculations needs to be adjusted for more realistic results.


