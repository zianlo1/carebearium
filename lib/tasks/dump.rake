require 'multi_json'
require 'oj'

desc "dump kills to json"
task dump_to_json: :environment do
  kills = KillStat.order(:created_at.asc).to_a.map{|s| s.attributes.slice('solar_system_id', 'ship_kills', 'pod_kills', 'npc_kills', 'created_at' ) }

  File.open(Rails.root.join('kills.json'), 'w') do |f|
    f.write(MultiJson.dump kills, pretty: false)
  end

  jumps = JumpStat.order(:created_at.asc).to_a.map{|s| s.attributes.slice('solar_system_id', 'jumps', 'created_at' ) }

  File.open(Rails.root.join('jumps.json'), 'w') do |f|
    f.write(MultiJson.dump jumps, pretty: false)
  end
end
