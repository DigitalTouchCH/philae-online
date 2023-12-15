class AddIsDomicileToOrdonnances < ActiveRecord::Migration[7.0]
  def change
    add_column :ordonnances, :is_domicile, :boolean, default: false
  end
end
