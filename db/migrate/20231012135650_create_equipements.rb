class CreateEquipements < ActiveRecord::Migration[7.0]
  def change
    create_table :equipements do |t|
      t.string :name

      t.timestamps
    end
  end
end
