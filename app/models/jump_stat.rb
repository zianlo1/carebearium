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

  def self.update
    ApiLog.call 'jumps', ->{ EveApi.jumps }, finally: -> { ApiLog.expire! 'aggregates' } do |row|
      create(solar_system_id: row['solarSystemID'], jumps: row['shipJumps'])
    end
  end
end
