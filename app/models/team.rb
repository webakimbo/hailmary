class Team < ApplicationRecord
  def full_name
    [city, name].join(" ")
  end
end
