class SimPick < ApplicationRecord
  belongs_to :sim_user_season
  belongs_to :week
  belongs_to :team
end
