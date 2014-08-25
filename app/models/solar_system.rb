class SolarSystem < ActiveRecord::Base
  has_many :agents, inverse_of: :solar_system
  has_many :stations, inverse_of: :solar_system

  def self.security(options)
    if options[:min] && options[:max]
      min = options[:min].to_f / 100
      max = options[:max].to_f / 100
      where security: min..max
    else
      self
    end
  end

  def self.belts(options)
    if options[:min] && options[:max]
      where belt_count: options[:min]..options[:max]
    else
      self
    end
  end
end

# == Schema Information
#
# Table name: solar_systems
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  region_name :string(255)
#  security    :float
#  belt_count  :integer
#  created_at  :datetime
#  updated_at  :datetime
#
