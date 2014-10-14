def read_file(filename)
  MultiJson.load File.read(Rails.root.join 'db', 'seeds', filename), symbolize_keys: true
end

p 'Preparing data'

systems  = {}

read_file('solar_systems.json').each do |row|
  system = row.slice(:regionID, :security, :belt_count, :moon_count, :x, :y, :z)

  system[:stations] = []
  system[:agents]   = []

  systems[row[:id]] = system
end

read_file('ice_belts.json').each do |row|
  systems[row[:id]][:ice] = true
end

read_file('stations.json').each do |row|
  next unless systems[row[:solarSystemID]]
  systems[row[:solarSystemID]][:stations] << row.slice(:id, :name, :operationID)
end

divisions = Set.new

read_file('agents.json').each do |row|
  next unless systems[row[:solarSystemID]]
  divisions.add row[:division]
  systems[row[:solarSystemID]][:agents] << row.slice(:id, :level, :division, :corporationID)
end

divisionMap = {}
divisions.to_a.sort.each_with_index do |division, index|
  divisionMap[division] = index
end

read_file('jumps.json').each do |row|
  next unless systems[row[:from]]
  systems[row[:from]][:jumps] = row[:to].split(',').map(&:to_i).sort
end

p 'Deleting old data'
SolarSystem.delete_all

p 'Writing new data'
systems.each do |id, system|
  attrs = {
    id:         id,
    region_id:  system[:regionID],
    security:   system[:security],
    belt_count: system[:belt_count],
    moon_count: system[:moon_count],
    ice:        !!system[:ice],
    jumps:      system[:jumps],
    x:          system[:x],
    y:          system[:y],
    z:          system[:z]
  }

  attrs[:stations] = system[:stations].each_with_object({}) do |station, stations|
    stations[station[:id]] = { name: station[:name], operation_id: station[:operationID] }
  end

  attrs[:agents] = system[:agents].each_with_object({}) do |agent, agents|
    agents[agent[:id]] = { level: agent[:level], division: divisionMap[agent[:division]], corporation_id: agent[:corporationID] }
  end

  SolarSystem.create(attrs)
end

p 'Forcing refresh'
ApiLog.without_hourly_updates.delete_all
Rake::Task['update'].invoke
