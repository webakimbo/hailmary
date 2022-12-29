class Pick < ApplicationRecord
  belongs_to :user_season
  belongs_to :week
  belongs_to :team
end
