module EnvVars

  def sim_mode?
    ENV['SIMULATION_MODE'].to_s.downcase == "true"
  end

end
