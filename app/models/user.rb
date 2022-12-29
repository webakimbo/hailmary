class User < ApplicationRecord
  has_many :user_seasons, dependent: :destroy
end
