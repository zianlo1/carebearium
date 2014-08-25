class SolarSystemSerializer < ActiveModel::Serializer
  attributes :id, :name, :region_name, :security, :belt_count, :stations_count, :agents_count, *SolarSystemFinders::INDUSTRIAL_INDEX_COLUMNS

  def security
    "%.2f" % object.security
  end

  SolarSystemFinders::INDUSTRIAL_INDEX_COLUMNS.each do |col|
    define_method col do
      "%.4f" % object.send(col)
    end
  end
end
