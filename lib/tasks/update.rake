namespace :update do
  task industry_indices: :environment do
    SolarSystem.update_industry_indices
  end

  task kill_stats: :environment do
    KillStat.update
  end

  task jump_stats: :environment do
    JumpStat.update
  end

  task aggregate_stats: :environment do
    SolarSystem.update_aggregate_stats
  end

  if Rails.env.development?
    task static_data: [ 'sde2seed', 'seed2public' ]
  end
end

task update: %w(industry_indices kill_stats jump_stats aggregate_stats).map{ |t| "update:#{t}" }
