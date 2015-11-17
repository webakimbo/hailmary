class Pick < ActiveRecord::Base
  belongs_to :user
  belongs_to :week
  belongs_to :competition
end
