class AddDetailsToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :name, :string
    add_column :locations, :address, :string
    add_column :locations, :acces_detail, :text
  end
end
