namespace :update do
  task industry_indices: :environment do
    SolarSystem.update_industry_indices
  end

  task kill_stats: :environment do
    KillStat.update
  end
end

task update: [ 'update:industry_indices' ]
