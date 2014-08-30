class Agent
  include Mongoid::Document

  embedded_in :station

  field :level,             type: Integer
  field :kind,              type: String
  field :corporation_name,  type: String
  field :locator,           type: Boolean
end
