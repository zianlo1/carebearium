class Station
  include Mongoid::Document

  embedded_in :solar_system
  embeds_many :agents

  field :name, type: String
end
