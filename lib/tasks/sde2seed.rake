if Rails.env.development?
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
        join mapSolarSystems s on s.solarSystemID = st.solarSystemID
        where round(s.security,1) >= 0.5
        order by a.agentID
      SQL
    end

    task :stations do
      dump_query 'stations.json', <<-SQL
        select st.stationID, st.solarSystemID, st.stationName
        from staStations st
        join mapSolarSystems s on s.solarSystemID = st.solarSystemID
        where round(s.security,1) >= 0.5
        order by stationID
      SQL
    end

    task :solar_systems do
      dump_query 'solar_systems.json', <<-SQL
        select s.solarSystemID as id, s.solarSystemName as name, r.regionName, round(s.security, 4) as security, IFNULL(belts.beltCount, 0) as beltCount
        from mapSolarSystems s
        join mapRegions r on s.regionID = r.regionID
        left join (select solarSystemID, count(*) as beltCount from mapDenormalize where typeID = 15 group by solarSystemID) belts on s.solarSystemID = belts.solarSystemID
        where round(s.security,1) >= 0.5
        order by s.solarSystemID
      SQL
    end

    task :jumps do
      dump_query 'jumps.json', <<-SQL
        select src.solarSystemId as 'from', dst.solarSystemId as 'to'
        from mapJumps j
        join mapDenormalize src on src.itemId = j.stargateId
        join mapDenormalize dst on dst.itemId = j.destinationId
        join mapSolarSystems srcSys on srcSys.solarSystemId = src.solarSystemId
        join mapSolarSystems dstSys on dstSys.solarSystemId = dst.solarSystemId
        where round(srcSys.security,1) >= 0.5 and round(dstSys.security,1) >= 0.5
        order by src.solarSystemId, dst.solarSystemId
      SQL
    end

    task :corporations do
      dump_query 'corporations.json', <<-SQL
        select c.corporationID as id, n.itemName as name
        from crpNPCCorporations c
        join invNames n on n.itemID = c.corporationID
        where exists (select 1 from agtAgents a
                      join staStations st on a.locationID = st.stationID
                      join mapSolarSystems s on s.solarSystemID = st.solarSystemID
                      where a.corporationID = c.corporationID
                      and round(s.security,1) >= 0.5)
        order by c.corporationID
      SQL
    end
  end

  desc "Convert SDE data to db seeds"
  task sde2seed: %w(agents stations solar_systems jumps corporations).map{ |t| "sde2seed:#{t}" }
end
