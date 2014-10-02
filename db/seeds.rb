def read_file(filename)
  MultiJson.load File.read(Rails.root.join 'db', 'seeds', filename), symbolize_keys: true
end

p 'Loading solar systems'
read_file('solar_systems.json').each do |row|
  SolarSystem.find_or_create_by(id: row[:id])
end
