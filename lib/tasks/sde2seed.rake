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
    task :agents do
      dump_query 'agents.json', <<-SQL
        select a.agentID as id, a.level, n.itemName as corporationName, d.divisionName as kind, st.stationID, st.solarSystemID, a.isLocator
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

    task :solar_systems do
      dump_query 'solar_systems.json', <<-SQL
        select s.solarSystemID as id, s.solarSystemName as name, r.regionName, round(s.security, 1) as security, IFNULL(belts.beltCount, 0) as beltCount
        from mapSolarSystems s
        join mapRegions r on s.regionID = r.regionID
        left join (select solarSystemID, count(*) as beltCount from mapDenormalize where typeID = 15 group by solarSystemID) belts on s.solarSystemID = belts.solarSystemID
        where round(s.security,1) >= 0.5
        order by s.solarSystemID
      SQL
    end

    task :jumps do
      jumps = exec <<-SQL
        select src.solarSystemId as 'from', dst.solarSystemId as 'to'
        from mapJumps j
        join mapDenormalize src on src.itemId = j.stargateId
        join mapDenormalize dst on dst.itemId = j.destinationId
        join mapSolarSystems srcSys on srcSys.solarSystemId = src.solarSystemId
        join mapSolarSystems dstSys on dstSys.solarSystemId = dst.solarSystemId
        where round(srcSys.security,1) >= 0.5 and round(dstSys.security,1) >= 0.5
        order by src.solarSystemId, dst.solarSystemId
      SQL

      jump_map = jumps.each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |jump, map|
        map[jump['from'].to_i] << jump['to'].to_i
      end

      distance_map = Hash.new { |hash, key| hash[key] = {} }

      jump_map.keys.each do |start|
        visit_next_round = Set.new jump_map[start]
        seen = Set.new jump_map[start]
        seen.add start
        depth = 1
        while visit_next_round.any?
          visit_now = visit_next_round.to_a
          visit_next_round = visit_next_round.clear
          visit_now.each do |current|
            distance_map[start][current] = depth
            jump_map[current].each do |nxt|
              unless seen.include?(nxt)
                visit_next_round.add(nxt)
                seen.add nxt
              end
            end
          end
          depth += 1
        end
      end

      File.open(Rails.root.join('db', 'seeds', 'distances.json'), 'w') do |f|
        f.write(JSON.pretty_generate distance_map)
      end
    end
  end

  desc "Convert SDE data to db seeds"
  task sde2seed: %w(agents stations solar_systems jumps).map{ |t| "sde2seed:#{t}" }
end
