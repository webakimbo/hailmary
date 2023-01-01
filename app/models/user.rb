class User < ApplicationRecord
  has_many :user_seasons, dependent: :destroy

  def full_name
    [first_name, last_name].join(" ")
  end
end
