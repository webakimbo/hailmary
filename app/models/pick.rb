class Pick < ActiveRecord::Base
  belongs_to :user
  belongs_to :competition
  belongs_to :matchup
end
