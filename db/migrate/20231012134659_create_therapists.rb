class CreateTherapists < ActiveRecord::Migration[7.0]
  def change
    create_table :therapists do |t|
      t.boolean :is_manager
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
