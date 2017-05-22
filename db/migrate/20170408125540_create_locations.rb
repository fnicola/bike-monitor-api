class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.belongs_to :station, index: true
      t.timestamps
    end
  end
end
