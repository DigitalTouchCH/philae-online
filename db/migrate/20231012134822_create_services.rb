class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.boolean :active
      t.string :name
      t.integer :duration_per_unit
      t.string :color
      t.boolean :is_group

      t.timestamps
    end
  end
end
