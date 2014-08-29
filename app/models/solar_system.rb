class SolarSystem
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  embeds_many :stations

  field :name,                      type: String
  field :region_name,               type: String
  field :security,                  type: Float
  field :belt_count,                type: Integer
  field :manufacturing_index,       type: Float, default: 0.0
  field :research_te_index,         type: Float, default: 0.0
  field :research_me_index,         type: Float, default: 0.0
  field :copying_index,             type: Float, default: 0.0
  field :reverse_engineering_index, type: Float, default: 0.0
  field :invention_index,           type: Float, default: 0.0
  field :distances,                 type: Hash,  default: {}

  def self.update_industry_indices
    CREST.industry_indices.each do |row|
      begin
        system = find row['solarSystem']['id']
        attrs = {}
        row['systemCostIndices'].each do |indexHash|
          case indexHash['activityID']
          when 1 then attrs[:manufacturing_index]       = indexHash['costIndex']
          when 3 then attrs[:research_te_index]         = indexHash['costIndex']
          when 4 then attrs[:research_me_index]         = indexHash['costIndex']
          when 5 then attrs[:copying_index]             = indexHash['costIndex']
          when 7 then attrs[:reverse_engineering_index] = indexHash['costIndex']
          when 8 then attrs[:invention_index]           = indexHash['costIndex']
          else nil
          end
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
