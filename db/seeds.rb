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
    belts_count:  row[:beltCount],
    distances:    distance_map[row[:id].to_s.to_sym]
  )
end

p 'Loading stations'
read_file('stations.json').each do |row|
  SolarSystem.find(row[:solarSystemID]).stations.find_or_initialize_by(id: row[:id]).update_attributes(
    name:       row[:name],
    refinery:   row[:refinery] == 1,
    repair:     row[:repair] == 1,
    factory:    row[:factory] == 1,
    lab:        row[:lab] == 1,
    insurance:  row[:insurance] == 1
  )
end

p 'Loading agents'
read_file('agents.json').each do |row|
  SolarSystem.find(row[:solarSystemID]).agents.find_or_initialize_by(id: row[:id]).update_attributes(
    station_id:       row[:stationID],
    corporation_name: row[:corporationName],
    level:            row[:level],
    kind:             row[:kind],
    locator:          row[:isLocator] == 1
  )
end

p 'Updating counters'
SolarSystem.all.each do |solar_system|
  solar_system.update_attributes(
    stations_count: solar_system.stations.size,
    agents_count:   solar_system.agents.size
  )
end
