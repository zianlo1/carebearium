class Station
  include Mongoid::Document

  embedded_in :solar_system

  field :name, type: String
  field :refinery, type: Boolean
  field :repair, type: Boolean
  field :factory, type: Boolean
  field :lab, type: Boolean
  field :insurance, type: Boolean
end
