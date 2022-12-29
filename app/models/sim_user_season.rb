class SimUserSeason < ApplicationRecord
  belongs_to :sim_user
  belongs_to :season
  has_many :sim_picks, dependent: :destroy
end
