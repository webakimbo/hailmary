class Pick < ActiveRecord::Base
  belongs_to :user
  belongs_to :week
  belongs_to :competition
  belongs_to :team
end
