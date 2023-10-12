class CreatePrescripteurs < ActiveRecord::Migration[7.0]
  def change
    create_table :prescripteurs do |t|
      t.string :name
      t.string :address
      t.string :tel

      t.timestamps
    end
  end
end
