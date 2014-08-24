class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string     :name
      t.references :solar_system
    end
  end
end
