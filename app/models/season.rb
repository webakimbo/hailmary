class Season < ApplicationRecord
  has_many :weeks
  include EnvVars

  def current_week
    if sim_mode?
      SimMatchup.where('final = ?', false)&.first&.week || SimMatchup.last.week
    else
      weeks.where.not('start > ?', DateTime.now)&.last || weeks.last
    end
  end

  def self.advance_week
    return unless new.sim_mode?
    next_unfinished = SimMatchup.where('final = ?', false)&.first
    if next_unfinished
      SimMatchup.where('week_id = ?', next_unfinished.week_id).update(final: true)
    end
  end

end
