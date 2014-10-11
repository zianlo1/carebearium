namespace :update do
  task dynamic_data: :environment do
    SolarSystem.update_industry_indices
    SolarSystem.update_conquerable_stations
    SolarSystem.update_sovereignty
    KillStat.update
    JumpStat.update
    SolarSystem.update_aggregate_stats
  end

  if Rails.env.development?
    task static_data: [ 'sde2seed', 'seed2public' ]
  end
end

task update: 'update:dynamic_data'
