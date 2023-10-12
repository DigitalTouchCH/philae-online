class AddPrescripteurToOrdonnances < ActiveRecord::Migration[7.0]
  def change
    add_reference :ordonnances, :prescripteur, null: false, foreign_key: true
  end
end
