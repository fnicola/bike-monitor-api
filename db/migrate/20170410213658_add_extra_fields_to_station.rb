class AddExtraFieldsToStation < ActiveRecord::Migration[5.0]
  def change
    add_column :stations, :name, :string
  end
end
