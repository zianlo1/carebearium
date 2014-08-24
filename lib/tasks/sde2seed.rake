require 'mysql2'

def dump_query(filename, query)
  client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'eve')

  File.open(Rails.root.join('db', 'seeds', filename), 'w') do |f|
    f.write(client.query(query).to_a.to_json)
  end
end

namespace :sde2seed do
  task :agents do
    dump_query 'agents.json', <<-SQL
      select a.agentID as id, a.level, a.corporationID, d.divisionName as kind, st.stationID, st.solarSystemID, a.isLocator
      from agtAgents a
      join crpNPCDivisions d on d.divisionID = a.divisionID
      join staStations st on a.locationID = st.stationID
      order by a.agentID
    SQL
  end

  task :stations do
    dump_query 'stations.json', <<-SQL
      select stationID, solarSystemID, stationName, reprocessingEfficiency, reprocessingStationsTake
      from staStations
      order by stationID
    SQL
  end

  task :solar_systems do
    dump_query 'solar_systems.json', <<-SQL
      select s.solarSystemID as id, s.solarSystemName as name, r.regionName, round(s.security, 4) as security, IFNULL(belts.beltCount, 0) as beltCount
      from mapSolarSystems s
      join mapRegions r on s.regionID = r.regionID
      left join (select solarSystemID, count(*) as beltCount from mapDenormalize where typeID = 15 group by solarSystemID) belts on s.solarSystemID = belts.solarSystemID
      order by s.solarSystemID
    SQL
  end
end

desc "Convert SDE data to db seeds"
task sde2seed: %w(agents stations solar_systems).map{ |t| "sde2seed:#{t}" }
