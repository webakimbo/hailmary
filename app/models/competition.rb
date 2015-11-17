class Competition < ActiveRecord::Base
  belongs_to :group
  belongs_to :season
  has_and_belongs_to_many :users

  def user_picks(user_id)
    Pick.where(user_id: user_id, competition_id: id)
  end

  def record(user_id)
    picks = user_picks(user_id)
    wl = picks.group_by{ |p| p.pick_correct }
    "#{wl[true].count rescue 0}-#{wl[false].count rescue 0}"
  end

  def points_awarded(user_id)
    picks = user_picks(user_id)
    picks.map{ |p| p.points_awarded }.reduce(:+)
  end

  def standings
    # users = 
  end

end
