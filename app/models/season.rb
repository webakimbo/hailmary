class Season < ActiveRecord::Base
  has_many :weeks
  has_many :competitions

  def next_deadline
    deadlines = weeks.map{ |week| week.deadline }
    past_future = deadlines.partition { |t| t.past? }
    return nil if past_future[1].empty?
    past_future[1].first
  end

  def current_week
    past_future = weeks.partition { |w| w.ends.past? }
    return nil if past_future[1].empty?
    past_future[1].first.name
  end

end
