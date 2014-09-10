class Station
  include Mongoid::Document

  SERVICE_FIELDS = %w(refinery repair factory lab insurance)

  embedded_in :solar_system

  field :name,      type: String
  field :refinery,  type: Boolean
  field :repair,    type: Boolean
  field :factory,   type: Boolean
  field :lab,       type: Boolean
  field :insurance, type: Boolean
end
