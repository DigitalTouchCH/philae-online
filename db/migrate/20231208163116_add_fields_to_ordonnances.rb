class AddFieldsToOrdonnances < ActiveRecord::Migration[7.0]
  def change
    add_column :ordonnances, :physiotherapy_objectiv, :text
    add_column :ordonnances, :treatment_plan, :text
    add_column :ordonnances, :progress_notes, :text
  end
end
