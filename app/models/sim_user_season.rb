class SimUserSeason < ApplicationRecord
  include UserSeasons

  # belongs_to :sim_user
  belongs_to :competitor, polymorphic: true
  belongs_to :season
  has_many :sim_picks, dependent: :destroy

  # alias_attribute :user, :sim_user
  alias_attribute :user, :competitor
  alias_attribute :picks, :sim_picks
  
end
