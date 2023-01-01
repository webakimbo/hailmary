class SimUserSeason < ApplicationRecord
  belongs_to :sim_user
  belongs_to :season
  has_many :sim_picks, dependent: :destroy

  alias_attribute :user, :sim_user
  alias_attribute :picks, :sim_picks
end
