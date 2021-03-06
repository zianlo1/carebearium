if Rails.env.development?
  require_relative 'task_helpers'
  require 'mysql2'

  def exec(query)
    Mysql2::Client.new(host: 'localhost', username: 'root', database: 'eve').query(query).to_a
  end

  def dump_query(filename, query)
    write_seed_file filename, exec(query)
  end

  namespace :sde2seed do
    task :solar_systems do
      dump_query 'solar_systems.json', <<-SQL
        select s.solarSystemID as id,
               s.solarSystemName as name,
               s.regionID,
               case when s.security between 0.0 and 0.05 then 0.1 else round(s.security, 1) end as security,
               IFNULL(belts.c, 0) as belt_count,
               IFNULL(moons.c, 0) as moon_count,
               round(x / 10000000000000000, 5) as x,
               round(y / 10000000000000000, 5) as y,
               round(z / 10000000000000000, 5) as z
        from mapSolarSystems s
        left join (select solarSystemID, count(*) as c from mapDenormalize where typeID = 15 group by solarSystemID) belts on s.solarSystemID = belts.solarSystemID
        left join (select solarSystemID, count(*) as c from mapDenormalize where typeID = 14 group by solarSystemID) moons on s.solarSystemID = moons.solarSystemID
        where s.regionID < 11000000
        and s.regionID not in (10000004, 10000017, 10000019)
        order by s.solarSystemID
      SQL
    end

    task :regions do
      dump_query 'regions.json', <<-SQL
        select regionID, regionName
        from mapRegions
        where regionID < 11000000
        and regionID not in (10000004, 10000017, 10000019)
        order by regionID
      SQL
    end

    task :stations do
      dump_query 'stations.json', <<-SQL
        select stationID as id, solarSystemID, stationName as name, operationID
        from staStations
        order by stationID
      SQL
    end

    task :agents do
      dump_query 'agents.json', <<-SQL
        select a.agentID as id, a.level, a.corporationID, d.divisionName as division, st.stationID, st.solarSystemID
        from agtAgents a
        join crpNPCDivisions d on d.divisionID = a.divisionID
        join staStations st on a.locationID = st.stationID
        join crpNPCCorporations c on c.corporationID = a.corporationID
        join invNames n on n.itemID = c.corporationID
        order by a.agentID
      SQL
    end

    task :corporations do
      dump_query 'corporations.json', <<-SQL
        select c.corporationID, n.itemName as corporationName
        from crpNPCCorporations c
        join invNames n on n.itemID = c.corporationID
        order by c.corporationID
      SQL
    end

    desc "Dump data about ice belts. Requires Retribution SDE or earlier."
    task :ice_belts do
      dump_query 'ice_belts.json', <<-SQL
        select s.solarSystemID as id, belts.beltCount as iceBeltCount
        from mapSolarSystems s
        join (select solarSystemID, count(*) as beltCount from mapDenormalize where typeID = 17774 group by solarSystemID) belts on s.solarSystemID = belts.solarSystemID
        order by s.solarSystemID
      SQL
    end

    task :jumps do
      dump_query 'jumps_raw.json', <<-SQL
        select src.solarSystemId as 'from', group_concat(dst.solarSystemId order by dst.solarSystemId) as 'to'
        from mapJumps j
        join mapDenormalize src on src.itemId = j.stargateId
        join mapDenormalize dst on dst.itemId = j.destinationId
        group by src.solarSystemId
        order by src.solarSystemId, dst.solarSystemId
      SQL
    end

    task :operations do
      dump_query 'operations.json', <<-SQL
        select operationID as id, group_concat(serviceID order by serviceID) as services
        from staOperationServices
        group by operationID
        order by operationID
      SQL
    end

    task :planets do
      dump_query 'planets.json', <<-SQL
        select m.solarSystemID, m.typeID, t.typeName, count(*) as count
        from mapDenormalize m
        join invTypes t on t.typeId = m.typeId
        where t.groupID = 7
        and m.regionID < 11000000
        and m.regionID not in (10000004, 10000017, 10000019)
        group by m.solarSystemID, m.typeID
        order by m.solarSystemID, m.typeID
      SQL
    end
  end

  desc "Convert SDE data to db seeds"
  task sde2seed: %w(solar_systems regions stations agents corporations jumps operations planets).map{ |t| "sde2seed:#{t}" }
end
