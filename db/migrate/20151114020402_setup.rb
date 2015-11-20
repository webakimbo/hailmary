class Setup < ActiveRecord::Migration
  def change

    create_table :users do |t|
      t.string    :first_name
      t.string    :last_name
      t.string    :handle, uniqueness: true
      t.string    :location
      t.string    :avatar
      t.string    :display_name_as
      t.string    :email, uniqueness: true
      t.string    :password
      t.boolean   :show_location
      t.boolean   :show_email
      t.boolean   :active
      t.timestamps null: false
    end

    create_table :groups do |t|
      t.string    :name
      t.string    :tagline
      t.string    :avatar
      t.integer   :administrator_user_id
      t.boolean   :active
      t.timestamps null: false
    end

    create_table :teams do |t|
      t.string    :name
      t.string    :abbr
      t.string    :city
      t.string    :logo
      t.boolean   :active
    end

    create_table :seasons do |t|
      t.integer   :year
      t.boolean   :current
    end

    create_table :weeks do |t|
      t.string    :name
      t.integer   :season_id
      t.datetime  :deadline
      t.datetime  :ends
    end

    create_table :matchups do |t|
      t.string    :event_id
      t.integer   :week_id
      t.string    :home_team
      t.string    :away_team
      t.datetime  :match_time
      t.integer   :home_score
      t.integer   :away_score
      t.boolean   :home_won
      t.boolean   :is_final
    end

    create_table :competitions do |t|
      t.integer   :group_id
      t.integer   :season_id
      t.decimal   :buyin, precision: 2, default: 0.00
    end

    create_table :picks do |t|
      t.integer   :user_id
      t.integer   :competition_id
      t.integer   :matchup_id
      t.boolean   :picked_home_team
      t.integer   :point_value_win
      t.integer   :point_value_lose
      t.boolean   :pick_correct
      t.integer   :points_awarded
      t.timestamps null: false
    end

    # create_table :groups_users, id: false do |t|
    #   t.integer   :user_id, index: true
    #   t.integer   :group_id, index: true
    # end

    # create_table :competitions_users, id: false do |t|
    #   t.integer   :user_id, index: true
    #   t.integer   :competition_id, index: true
    #   t.boolean   :paid
    #   t.boolean   :active
    # end
    
  end
end
