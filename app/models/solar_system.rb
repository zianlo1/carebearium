class SolarSystem < ActiveRecord::Base
  has_many :agents, inverse_of: :solar_system
  has_many :stations, inverse_of: :solar_system
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
