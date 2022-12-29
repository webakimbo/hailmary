class InitialSetup < ActiveRecord::Migration[7.0]
  def change

    # #####################
    #  Live data
    # #####################

    # USERS
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :text
      t.string :contact_preference, default: "text"
    
      t.timestamps
    end

    # TEAMS
    create_table :teams do |t|
      t.string :city
      t.string :name
      t.string :abbr
      t.string :conference
      t.string :division
    
      t.timestamps
    end

    # SEASONS
    create_table :seasons do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
    
      t.timestamps
    end

    # WEEKS
    create_table :weeks do |t|
      t.integer :week
      t.references :season
      t.datetime :start
      t.datetime :end
    
      t.timestamps
    end

    # USER SEASONS
    create_table :user_seasons do |t|
      t.references :user
      t.references :season
      t.integer :points, default: 0
    
      t.timestamps
    end

    # MATCHUPS
    create_table :matchups do |t|
      t.references :week
      t.datetime :kickoff
      t.string :location
      t.boolean :final, default: false

      t.timestamps
    end

    # MATCHUP TEAMS
    create_table :matchup_teams do |t|
      t.references :matchup
      t.references :team
      t.boolean :home, default: false
      t.integer :score, default: 0
      t.boolean :won, default: false

      t.timestamps
    end

    # USER PICKS
    create_table :picks do |t|
      t.references :user_season
      t.references :week
      t.references :team
      t.decimal :odds, precision: 6, scale: 5, default: 0.500
      t.boolean :correct, default: false
      t.integer :points, default: 0

      t.timestamps
    end


    # #####################
    #  Simulation data
    # #####################

    # USERS
    create_table :sim_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :text
      t.string :contact_preference, default: "text"
    
      t.timestamps
    end

    # USER SEASONS
    create_table :sim_user_seasons do |t|
      t.references :sim_user
      t.references :season
      t.integer :points, default: 0
    
      t.timestamps
    end

    # MATCHUPS
    create_table :sim_matchups do |t|
      t.references :week
      t.datetime :kickoff
      t.string :location
      t.boolean :final, default: false

      t.timestamps
    end

    # MATCHUP TEAMS
    create_table :sim_matchup_teams do |t|
      t.references :sim_matchup
      t.references :team
      t.decimal :strength, precision: 6, scale: 5, default: 0.500
      t.boolean :home, default: false
      t.integer :score, default: 0
      t.boolean :won, default: false

      t.timestamps
    end

    # USER PICKS
    create_table :sim_picks do |t|
      t.references :sim_user_season
      t.references :week
      t.references :team
      t.decimal :odds, precision: 6, scale: 5, default: 0.500
      t.boolean :correct, default: false
      t.integer :points, default: 0

      t.timestamps
    end

  end
end
