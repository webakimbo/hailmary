module CompetitionsHelper

  # http://oddsconverter.co.uk/
  # 
  # Moneyline Odds (Also known as American)
  # - Used by most US bookmakers.
  # - Based on a straight single bet (on a single outcome, without a points spread)
  # - If the moneyline is positive, the amount quoted is the amount you would win on a $100 bet.
  # - If it is negative, the amount quoted is what you would need to bet to win $100.
  # 
  # To convert moneyline odds to decimal, 
  # if the moneyline is positive, divide by 100 and add 1. 
  # If it is negative, divide 100 by the moneyline amount (without the minus sign) and add 1. 
  # To convert fractional odds to decimal, divide the first figure by the second figure add 1.00 (so 11/4 = 2.75, then add 1.00 = 3.75).
  
  def moneyline2pts(moneyline)
    odds2pts moneyline2odds(moneyline)
  end

  def get_logo_from_team_name(full_name)
    team = @teams.find{ |team| team.full_name.eql?(full_name) }
    return "" if team.nil?
    image_tag team.logo.url, class: 'logo'
  end

  private

  def moneyline2odds(moneyline)
    ml = moneyline.to_f
    if ml >= 0
      return ml/100 + 1
    else
      return 100/ml.abs + 1
    end
  end

  def odds2pts(ratio)
    (ratio * 100).round
  end

end
