if Rails.env.development?
  require 'mysql2'

  def exec(query)
    Mysql2::Client.new(host: 'localhost', username: 'root', database: 'eve').query(query).to_a
  end

  def dump_query(filename, query)
    File.open(Rails.root.join('db', 'seeds', filename), 'w') do |f|
      f.write(JSON.pretty_generate exec query)
    end
  end

  namespace :sde2seed do
    task :solar_systems do
      dump_query 'solar_systems.json', <<-SQL
        select s.solarSystemID as id, s.solarSystemName as name, s.regionID, round(s.security, 1) as security, IFNULL(belts.beltCount, 0) as beltCount
        from mapSolarSystems s
        left join (select solarSystemID, count(*) as beltCount from mapDenormalize where typeID = 15 group by solarSystemID) belts on s.solarSystemID = belts.solarSystemID
        where round(s.security,1) >= 0.5
        order by s.solarSystemID
      SQL
    end

    task :regions do
      dump_query 'regions.json', <<-SQL
        select r.regionID, r.regionName
        from mapRegions r
        join mapSolarSystems s on r.regionID = s.regionID
        where round(s.security,1) >= 0.5
        group by r.regionID
        order by r.regionID
      SQL
    end

    task :stations do
      dump_query 'stations.json', <<-SQL
        select st.stationID as id,
        	   st.solarSystemID,
        	   st.stationName as name,
        	   count(refine.operationID) as refinery,
        	   count(rep.operationID) as 'repair',
        	   count(factory.operationID) as factory,
        	   count(lab.operationID) as lab,
        	   count(insure.operationID) as insurance
        from staStations st
        join mapSolarSystems s on s.solarSystemID = st.solarSystemID
        left join staOperationServices refine on refine.operationID = st.operationID and refine.serviceID = 32
        left join staOperationServices rep on rep.operationID = st.operationID and rep.serviceID = 4096
        left join staOperationServices factory on factory.operationID = st.operationID and factory.serviceID = 8192
        left join staOperationServices lab on lab.operationID = st.operationID and lab.serviceID = 16384
        left join staOperationServices insure on insure.operationID = st.operationID and insure.serviceID = 1048576
        where round(s.security,1) >= 0.5
        group by st.stationID
        order by st.stationID
      SQL
    end

    task :agents do
      dump_query 'agents.json', <<-SQL
        select a.agentID as id, a.level, a.corporationID, d.divisionName as kind, st.stationID, st.solarSystemID
        from agtAgents a
        join crpNPCDivisions d on d.divisionID = a.divisionID
        join staStations st on a.locationID = st.stationID
        join mapSolarSystems s on s.solarSystemID = st.solarSystemID
        join crpNPCCorporations c on c.corporationID = a.corporationID
        join invNames n on n.itemID = c.corporationID
        where round(s.security,1) >= 0.5
        order by a.agentID
      SQL
    end

    task :corporations do
      dump_query 'corporations.json', <<-SQL
        select c.corporationID, n.itemName as corporationName
        from agtAgents a
        join crpNPCDivisions d on d.divisionID = a.divisionID
        join staStations st on a.locationID = st.stationID
        join mapSolarSystems s on s.solarSystemID = st.solarSystemID
        join crpNPCCorporations c on c.corporationID = a.corporationID
        join invNames n on n.itemID = c.corporationID
        where round(s.security,1) >= 0.5
        group by c.corporationID
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
      dump_query 'jumps.json', <<-SQL
        select src.solarSystemId as 'from', group_concat(dst.solarSystemId) as 'to'
        from mapJumps j
        join mapDenormalize src on src.itemId = j.stargateId
        join mapDenormalize dst on dst.itemId = j.destinationId
        join mapSolarSystems srcSys on srcSys.solarSystemId = src.solarSystemId
        join mapSolarSystems dstSys on dstSys.solarSystemId = dst.solarSystemId
        where round(srcSys.security,1) >= 0.5 and round(dstSys.security,1) >= 0.5
        group by src.solarSystemId
        order by src.solarSystemId, dst.solarSystemId
      SQL
    end
  end

  desc "Convert SDE data to db seeds"
  task sde2seed: %w(solar_systems regions stations agents corporations jumps).map{ |t| "sde2seed:#{t}" }
end
