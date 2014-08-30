class SolarSystem
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  embeds_many :stations
  embeds_many :agents

  field :name,                      type: String
  field :region_name,               type: String
  field :security,                  type: Float
  field :belts_count,               type: Integer, default: 0
  field :stations_count,            type: Integer, default: 0
  field :agents_count,              type: Integer, default: 0
  field :manufacturing_index,       type: Float,   default: 0.0
  field :research_te_index,         type: Float,   default: 0.0
  field :research_me_index,         type: Float,   default: 0.0
  field :copying_index,             type: Float,   default: 0.0
  field :reverse_engineering_index, type: Float,   default: 0.0
  field :invention_index,           type: Float,   default: 0.0
  field :distances,                 type: Hash,    default: {}

  def self.update_industry_indices
    CREST.industry_indices.each do |row|
      begin
        system = find row['solarSystem']['id']
        attrs  = {}
        row['systemCostIndices'].each do |item|
          key = case item['activityID']
                when 1 then :manufacturing_index
                when 3 then :research_te_index
                when 4 then :research_me_index
                when 5 then :copying_index
                when 7 then :reverse_engineering_index
                when 8 then :invention_index
                else
                  next
                end

          attrs[key] = item['costIndex']
        end
        system.update_attributes attrs
      rescue Mongoid::Errors::DocumentNotFound
        nil
      rescue => e
        Rails.logger.warn "#{e} updating indices: #{row}"
      end
    end
  end
end
