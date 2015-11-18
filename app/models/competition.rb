class Competition < ActiveRecord::Base
  belongs_to :group
  belongs_to :season

  def users
    group.users
  end

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

  def place(user_id)
    # Get all performances to date for this competition
    u = users.map{ |user|
      { id: user.id, display_name: user.display_name, record: record(user.id), point_total: points_awarded(user.id) }
    }
    grouped = u.group_by{ |user| user[:point_total] }.sort_by{ |k,v| k }.reverse.to_h

    # Locate this user
    pts = points_awarded(user_id)
    p = 0
    tied = false
    grouped.each{ |k, group|
      if k.to_i > pts
        p += group.count
      else
        p += 1
        tied = true if group.count > 1
        break
      end
    }

    # Return
    "#{'T-' if tied}#{p.ordinalize}"
  end

  def standings
    u = users.map{ |user|
      { id: user.id, display_name: user.display_name, record: record(user.id), point_total: points_awarded(user.id) }
    }
    u.sort_by{ |user| user[:point_total] }.reverse
  end

end
