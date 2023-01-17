module UserSeasons

  def already_picked_ids
    picks.map{|pick| pick.matchup_team.team_id }
  end

  def pick(week_id)
    # picks.where(week_id: week_id)&.first&.team_id
    picks.where(week_id: week_id)&.first
  end

end
