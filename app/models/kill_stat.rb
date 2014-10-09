class KillStat
  include IsSystemStatistic

  field :ship_kills, type: Integer
  field :pod_kills,  type: Integer
  field :npc_kills,  type: Integer

  MAP_FUNCTION = <<-JS.freeze
    function() {
      emit(this.solar_system_id, { ship_kills: this.ship_kills, pod_kills: this.pod_kills, npc_kills: this.npc_kills });
    }
  JS

  REDUCE_FUNCTION = <<-JS.freeze
    function(key, values) {
      var result = { ship_kills: 0, pod_kills: 0, npc_kills: 0 };
      values.forEach(function(value) {
        result.ship_kills += value.ship_kills;
        result.pod_kills  += value.pod_kills;
        result.npc_kills  += value.npc_kills;
      });
      return result;
    }
  JS

  DEFAULT_SUMMARY = { ship_kills: 0, pod_kills: 0, npc_kills: 0 }.freeze

  API_NAME = 'kills'

  def self.update
    return unless ApiLog.expired? API_NAME

    api_response = EveApi.kills

    api_response[:rows].each do |row|
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

    ApiLog.log API_NAME, api_response[:expires_at]
  end
end
