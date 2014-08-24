class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.references :corporation
      t.references :station
      t.references :solar_system
      t.integer :level
      t.string  :kind
      t.boolean :locator
    end
  end
end
