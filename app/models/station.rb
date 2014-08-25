class Station < ActiveRecord::Base
  belongs_to :solar_system, counter_cache: true
  has_many :agents, inverse_of: :station
end

# == Schema Information
#
# Table name: stations
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  solar_system_id :integer
#  agents_count    :integer          default(0)
#
