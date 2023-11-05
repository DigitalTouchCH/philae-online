class AddTitleToOrdonnances < ActiveRecord::Migration[7.0]
  def change
    add_column :ordonnances, :title, :string
  end
end
