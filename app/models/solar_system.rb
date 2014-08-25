class SolarSystem < ActiveRecord::Base
  include SolarSystemFinders

  has_many :agents, inverse_of: :solar_system
  has_many :stations, inverse_of: :solar_system

  def self.update_crest_indices
    SolarSystem.transaction do
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
        rescue ActiveRecord::RecordNotFound
          nil
        rescue => e
          Rails.logger.warn "#{e} updating indices: #{row}"
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: solar_systems
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  region_name               :string(255)
#  security                  :float
#  belt_count                :integer
#  agents_count              :integer          default(0)
#  stations_count            :integer          default(0)
#  manufacturing_index       :float            default(0.0)
#  research_te_index         :float            default(0.0)
#  research_me_index         :float            default(0.0)
#  copying_index             :float            default(0.0)
#  reverse_engineering_index :float            default(0.0)
#  invention_index           :float            default(0.0)
#  created_at                :datetime
#  updated_at                :datetime
#
