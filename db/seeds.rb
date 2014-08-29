def read_file(filename)
  MultiJson.load File.read(Rails.root.join 'db', 'seeds', filename), symbolize_keys: true
end

p 'Loading distance map'
distance_map = read_file('distances.json')

p 'Loading solar systems'
read_file('solar_systems.json').each do |row|
  SolarSystem.find_or_initialize_by(id: row[:id]).update_attributes(
    name:         row[:name],
    region_name:  row[:regionName],
    security:     row[:security],
    belt_count:   row[:beltCount],
    distances:    distance_map[row[:id].to_s.to_sym]
  )
end

p 'Loading stations'
read_file('stations.json').each do |row|
  SolarSystem.find(row[:solarSystemID]).stations.find_or_initialize_by(id: row[:id]).update_attributes(
    name: row[:name]
  )
end

p 'Loading agents'
read_file('agents.json').each do |row|
  SolarSystem.find(row[:solarSystemID]).stations.find_by(id: row[:stationID]).agents.find_or_initialize_by(id: row[:id]).update_attributes(
    corporation_name: row[:corporationName],
    level:            row[:level],
    kind:             row[:kind],
    locator:          row[:isLocator] == 1
  )
end
