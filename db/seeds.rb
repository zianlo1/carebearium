def read_file(filename)
  MultiJson.load File.read(Rails.root.join 'db', 'seeds', filename), symbolize_keys: true
end

p 'Loading solar systems'
SolarSystem.delete_all
read_file('solar_systems.json').each do |row|
  SolarSystem.find_or_create_by(id: row[:id])
end

p 'Updating aggregate stats'
SolarSystem.update_aggregate_stats
