def read_file(filename)
  MultiJson.load File.read(Rails.root.join 'db', 'seeds', filename), symbolize_keys: true
end

SolarSystem.transaction do
  p 'Loading jump map'
  jump_map = read_file('jumps.json')

  p 'Loading solar systems'
  read_file('solar_systems.json').each do |row|
    SolarSystem.where(id: row[:id]).first_or_initialize.update_attributes(
      name:         row[:name],
      region_name:  row[:regionName],
      security:     row[:security],
      belt_count:   row[:beltCount],
      jumps:        jump_map[row[:id].to_s.to_sym]
    )
  end
end

Station.transaction do
  p 'Loading stations'
  read_file('stations.json').each do |row|
    Station.where(id: row[:id]).first_or_initialize.update_attributes(
      solar_system_id:  row[:solarSystemID],
      name:             row[:name]
    )
  end
end

Corporation.transaction do
  p 'Loading corporations'
  read_file('corporations.json').each do |row|
    Corporation.where(id: row[:id]).first_or_initialize.update_attributes(
      name: row[:name]
    )
  end
end

Agent.transaction do
  p 'Loading agents'
  read_file('agents.json').each do |row|
    Agent.where(id: row[:id]).first_or_initialize.update_attributes(
      corporation_id:   row[:corporationID],
      station_id:       row[:stationID],
      level:            row[:level],
      kind:             row[:kind],
      solar_system_id:  row[:solarSystemID],
      locator:          row[:isLocator] == 1
    )
  end
end
