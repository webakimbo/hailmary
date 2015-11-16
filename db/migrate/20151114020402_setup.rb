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
      t.integer   :id_admin_user
      t.boolean   :active
      t.timestamps null: false
    end

    create_table :seasons do |t|
      t.integer   :year
      t.boolean   :current
      t.decimal   :buyin, precision: 2
    end

    create_table :weeks do |t|
      t.string    :week
      t.integer   :id_season
      t.datetime  :deadline
    end

    create_table :picks do |t|
      t.integer   :id_user
      t.integer   :id_week
      t.integer   :id_team
      t.integer   :id_opponent
      t.integer   :id_favorite
      t.string    :odds
      t.integer   :point_value
      t.boolean   :pick_correct
      t.integer   :points_awarded
      t.timestamps null: false
    end

    create_table :teams do |t|
      t.string    :name
      t.string    :abbr
      t.string    :city
      t.string    :logo
      t.boolean   :active
    end

    create_table :users_groups do |t|
      t.integer   :id_user
      t.integer   :id_group
      t.timestamps null: false
    end

    create_table :users_seasons do |t|
      t.integer   :id_user
      t.integer   :id_season
      t.boolean   :paid
      t.boolean   :active
      t.timestamps null: false
    end
    
  end
end
