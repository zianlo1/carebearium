class KillStat
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :solar_system_id, type: Integer
  field :ship_kills,      type: Integer
  field :pod_kills,       type: Integer
  field :npc_kills,       type: Integer

  index({ created_at: 1 }, { expire_after_seconds: 1.day })

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
end
