class Agent
  include Mongoid::Document

  embedded_in :solar_system

  field :station_id,        type: Integer
  field :level,             type: Integer
  field :kind,              type: String
  field :corporation_name,  type: String
  field :locator,           type: Boolean
end
