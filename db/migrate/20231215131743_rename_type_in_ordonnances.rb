class RenameTypeInOrdonnances < ActiveRecord::Migration[7.0]
  def change
    rename_column :ordonnances, :type, :type_of_ordonnance
  end
end
