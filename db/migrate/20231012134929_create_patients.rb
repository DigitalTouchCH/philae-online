class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.integer :age
      t.text :address
      t.string :tel1
      t.string :tel2
      t.string :contact_name
      t.string :contact_info
      t.string :contact_tel

      t.timestamps
    end
  end
end
