class CreateVideoPatients < ActiveRecord::Migration[7.0]
  def change
    create_table :video_patients do |t|
      t.date :valid_form
      t.date :valid_until
      t.text :instruction

      t.timestamps
    end
  end
end
