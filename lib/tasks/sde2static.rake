require 'mysql2'

def dump_query(filename, query)
  client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'eve')

  File.open(Rails.root.join('db', 'seeds', filename), 'w') do |f|
    f.write(client.query(query).to_a.to_json)
  end
end

namespace :sde2static do
  desc "Convert agent data"
  task :agents do
    dump_query 'agents.json', <<-SQL
      select a.agentID as id, a.level, a.corporationID, d.divisionName as kind, st.stationID, st.solarSystemID, a.isLocator
      from agtAgents a
      join crpNPCDivisions d on d.divisionID = a.divisionID
      join staStations st on a.locationID = st.stationID
      order by a.agentID
    SQL
  end
end

desc "Convert SDE data to db seeds"
task sde2static: [
  'sde2static:agents'
]
