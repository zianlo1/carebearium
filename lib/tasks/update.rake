namespace :update do
  task industry_indices: :environment do
    SolarSystem.update_industry_indices
  end
end

task update: [ 'update:industry_indices' ]
