class KillStat
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :solar_system

  field :solar_system_id, type: Integer
  field :ship_kills,      type: Integer
  field :pod_kills,       type: Integer
  field :npc_kills,       type: Integer

  index({ created_at: 1 }, { expire_after_seconds: 1.week })
  index({ solar_system_id: 1 })

  def self.update
    EveApi.kills.each do |row|
      begin
        create(
          solar_system_id: row['solarSystemID'],
          ship_kills:      row['shipKills'],
          pod_kills:       row['podKills'],
          npc_kills:       row['factionKills']
        )
      rescue => e
        Rails.logger.warn "#{e} updating kills: #{row}"
      end
    end
  end

  def self.hours_of_data
    ((max(:created_at) - min(:created_at)) / 60 / 60).to_i + 1
  end

  def self.summary
    results = Hash.new { |hash, key| hash[key] = { ship_kills: 0, pod_kills: 0, npc_kills: 0 } }

    map = %Q{
      function() {
        emit(this.solar_system_id, { ship_kills: this.ship_kills, pod_kills: this.pod_kills, npc_kills: this.npc_kills });
      }
    }

    reduce = %Q{
      function(key, values) {
        var result = { ship_kills: 0, pod_kills: 0, npc_kills: 0 };
        values.forEach(function(value) {
          result.ship_kills += value.ship_kills;
          result.pod_kills  += value.pod_kills;
          result.npc_kills  += value.npc_kills;
        });
        return result;
      }
    }

    map_reduce(map, reduce).out(inline: true).each do |row|
      results[row['_id'].to_i] = row['value']
    end

    results
  end
end
