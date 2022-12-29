class UserSeason < ApplicationRecord
  belongs_to :user
  belongs_to :season
  has_many :picks, dependent: :destroy
end
