class CreateCorporations < ActiveRecord::Migration
  def change
    create_table :corporations do |t|
      t.string  :name
      t.integer :agents_count, default: 0
    end
  end
end
