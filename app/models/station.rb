class Station
  include Mongoid::Document

  embedded_in :solar_system

  field :name, type: String
end
