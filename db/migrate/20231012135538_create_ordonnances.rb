class CreateOrdonnances < ActiveRecord::Migration[7.0]
  def change
    create_table :ordonnances do |t|
      t.date :date_prescription
      t.integer :num_of_session

      t.timestamps
    end
  end
end
