module IsSystemStatistic
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    field :solar_system_id, type: Integer

    index({ created_at: 1 }, { expire_after_seconds: 1.week })
  end

  module ClassMethods
    def summary
      results = Hash.new { |hash, key| hash[key] = self::DEFAULT_SUMMARY.dup }

      map_reduce(self::MAP_FUNCTION, self::REDUCE_FUNCTION).out(inline: true).each do |row|
        results[row['_id'].to_i] = row['value']
      end

      results
    end

    def hourly_summary
      results = summary
      scale   = hours_of_data

      results.each do |system_id, values|
        results[system_id].each do |field, value|
          results[system_id][field] = value.to_f / scale
        end
      end

      results
    end

    private

    def hours_of_data
      ((max(:created_at) - min(:created_at)) / 1.hour).to_i + 1
    end
  end
end
