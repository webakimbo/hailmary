namespace :db do
  task :seed_user, [:first_name, :last_name, :email, :phone] => [:environment] do |_t, args|
    sim_user_args = {
      first_name: args[:first_name],
      last_name: args[:last_name],
      email: args[:email],
      phone: args[:phone],
    }
    sim_user = SimUser.create!(sim_user_args)
    SimUserSeason.create!(sim_user: sim_user, season: Season.first)
    SimAppAdminRole.create!(sim_user: sim_user)
  end
end