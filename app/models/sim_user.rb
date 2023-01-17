class SimUser < ApplicationRecord
  has_many :sim_user_seasons

  def full_name
    [first_name, last_name].join(" ")
  end
end
