class Station
  include Mongoid::Document

  embedded_in :solar_system
  embeds_many :agents

  field :name, type: String
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
