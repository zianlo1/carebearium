class SolarSystem
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  has_many :kill_stats

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
  )

  DATA_FIELDS.each do |f|
    field f, type: Float, default: 0.0
  end

  def self.dynamic_data
    all.each_with_object({}) do |solar_sytem, map|
      map[solar_sytem.id] = solar_sytem.attributes.slice(*DATA_FIELDS)
    end
  end

  def self.dynamic_limits
    DATA_FIELDS.each_with_object({}) do |field, map|
      map[field] = { min: 0, max: max(field) }
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

  def self.update_kill_stats
    each do |solar_sytem|
      solar_sytem.update_attributes(
        hourly_ships: (solar_sytem.kill_stats.sum(:ship_kills).to_f / 24).round(5),
        hourly_pods:  (solar_sytem.kill_stats.sum(:pod_kills).to_f  / 24).round(5),
        hourly_npcs:  (solar_sytem.kill_stats.sum(:npc_kills).to_f  / 24).round(5)
      )
    end
  end
end
