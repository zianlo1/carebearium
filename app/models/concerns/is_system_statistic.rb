module IsSystemStatistic
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    belongs_to :solar_system

    field :solar_system_id, type: Integer

    index({ created_at: 1 }, { expire_after_seconds: 1.week })
    index({ solar_system_id: 1 })
  end

  module ClassMethods
    def hours_of_data
      ((max(:created_at) - min(:created_at)) / 60 / 60).to_i + 1
    end

    def summary
      results = Hash.new { |hash, key| hash[key] = self::DEFAULT_SUMMARY.dup }

      map_reduce(self::MAP_FUNCTION, self::REDUCE_FUNCTION).out(inline: true).each do |row|
        results[row['_id'].to_i] = row['value']
      end

      results
    end
  end
end
