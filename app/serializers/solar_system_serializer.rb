class SolarSystemSerializer < ActiveModel::Serializer
  attributes :id, :name, :region_name, :security, :belt_count, :stations_count, :agents_count
end
