class Season < ActiveRecord::Base
  has_many :weeks
  has_many :competitions

  def next_deadline
    deadlines = weeks.map{ |week| week.deadline }
    past_future = deadlines.partition{ |t| t.past? }
    return nil if past_future[1].empty?
    past_future[1].first
  end

  def current_week
    past_future = weeks.partition{ |w| w.ends.past? }
    return nil if past_future[1].empty?
    past_future[1].first.name
  end

  def pick_window_closed?
    dl = next_deadline
    return true if dl.nil? or current_week.nil?
    past_future = weeks.partition{ |w| w.ends.past? }
    past_future[1].first.ends.to_i < dl.to_i
  end

end
