class SolarSystem
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  DATA_FIELDS = %w(
    manufacturing
    research_te
    research_me
    copying
    reverse_engineering
    invention
    hourly_ships
    hourly_pods
    hourly_npcs
    hourly_jumps
  )

  DATA_FIELDS.each do |f|
    field f, type: Float, default: 0.0
  end

  def self.dynamic_data
    Rails.cache.fetch "SolarSystem#dynamic_data/#{max(:updated_at).to_i}" do
      all.each_with_object({}) do |solar_sytem, map|
        map[solar_sytem.id] = DATA_FIELDS.map { |field| solar_sytem.send(field) }
      end
    end
  end

  def self.limits_json
    Rails.cache.fetch "SolarSystem#limits/#{max(:updated_at).to_i}" do
      static_limits = MultiJson.load File.read(Rails.root.join 'public', 'api', 'limits_static.json')

      DATA_FIELDS.each_with_object(static_limits) do |field, map|
        map[field] = { min: 0, max: max(field) }
      end.to_json
    end
  end

  def self.update_industry_indices
    CREST.industry_indices.each do |row|
      begin
        system = find row['solarSystem']['id']
        attrs  = {}
        row['systemCostIndices'].each do |item|
          key = case item['activityID']
                when 1 then :manufacturing
                when 3 then :research_te
                when 4 then :research_me
                when 5 then :copying
                when 7 then :reverse_engineering
                when 8 then :invention
                else
                  next
                end

          attrs[key] = item['costIndex'].to_f.round(5)
        end
        system.update_attributes attrs
      rescue Mongoid::Errors::DocumentNotFound
        nil
      rescue => e
        Rails.logger.warn "#{e} updating indices: #{row}"
      end
    end
  end

  def self.update_aggregate_stats
    kill_summary = KillStat.summary
    kill_hours   = KillStat.hours_of_data

    jump_summary = JumpStat.summary
    jump_hours   = JumpStat.hours_of_data

    each do |solar_sytem|
      kill_stats = kill_summary[solar_sytem.id.to_i]
      jump_stats = jump_summary[solar_sytem.id.to_i]

      solar_sytem.update_attributes(
        hourly_ships: (kill_stats[:ship_kills].to_f / kill_hours).round(1),
        hourly_pods:  (kill_stats[:pod_kills].to_f  / kill_hours).round(1),
        hourly_npcs:  (kill_stats[:npc_kills].to_f  / kill_hours).round(1),
        hourly_jumps: (jump_stats[:jumps].to_f      / jump_hours).round(1)
      )
    end
  end
end
