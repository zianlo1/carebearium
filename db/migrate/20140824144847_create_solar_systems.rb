class CreateSolarSystems < ActiveRecord::Migration
  def change
    create_table :solar_systems do |t|
      t.string  :name
      t.string  :region_name
      t.float   :security
      t.integer :belt_count
      t.integer :agents_count,   default: 0
      t.integer :stations_count, default: 0
      t.timestamps
    end
  end
end
