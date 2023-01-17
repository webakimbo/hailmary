class AddUniquenessConstraints < ActiveRecord::Migration[7.0]
  def change
    add_index :picks, [:user_season_id, :week_id], unique: true
    add_index :sim_picks, [:sim_user_season_id, :week_id], unique: true
  end
end
