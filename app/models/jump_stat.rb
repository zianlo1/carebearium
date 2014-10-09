class JumpStat
  include IsSystemStatistic

  field :jumps, type: Integer

  MAP_FUNCTION = <<-JS.freeze
    function() {
      emit(this.solar_system_id, { jumps: this.jumps });
    }
  JS

  REDUCE_FUNCTION = <<-JS.freeze
    function(key, values) {
      var result = { jumps: 0 };
      values.forEach(function(value) {
        result.jumps += value.jumps;
      });
      return result;
    }
  JS

  DEFAULT_SUMMARY = { jumps: 0 }.freeze

  API_NAME = 'jumps'

  def self.update
    return unless ApiLog.expired? API_NAME

    api_response = EveApi.jumps

    api_response[:rows].each do |row|
      begin
        create(
          solar_system_id: row['solarSystemID'],
          jumps:           row['shipJumps']
        )
      rescue => e
        Rails.logger.warn "#{e} updating jumps: #{row}"
      end
    end

    ApiLog.log API_NAME, api_response[:expires_at]
  end
end
