class SolarSystemSerializer < ActiveModel::Serializer
  attributes :id, :name, :region_name, :security, :belt_count, :stations_count, :agents_count,
    :manufacturing_index, :research_te_index, :research_me_index, :copying_index, :reverse_engineering_index, :invention_index
end
