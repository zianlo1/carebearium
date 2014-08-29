class Agent
  include Mongoid::Document

  embedded_in :station

  field :level,             type: Integer
  field :kind,              type: String
  field :corporation_name,  type: String
  field :locator,           type: Boolean
end

# == Schema Information
#
# Table name: agents
#
#  id              :integer          not null, primary key
#  corporation_id  :integer
#  station_id      :integer
#  solar_system_id :integer
#  level           :integer
#  kind            :string(255)
#  locator         :boolean
#
