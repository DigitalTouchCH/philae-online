class AddDetailsToOrdonnances < ActiveRecord::Migration[7.0]
  def change
    add_column :ordonnances, :diagnostic, :string
    add_column :ordonnances, :type, :string
  end
end
