class SimAppAdminRole < ApplicationRecord
  belongs_to :sim_user
  alias_attribute :user, :sim_user
end
