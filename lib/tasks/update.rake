namespace :update do
  task industry_indices: :environment do
    SolarSystem.update_industry_indices
  end

  task system_kill_stats: :environment do
    SolarSystem.update_kill_stats
  end

  task kill_stats: :environment do
    KillStat.update
  end
end

task update: [ 'update:industry_indices', 'update:system_kill_stats' ]
