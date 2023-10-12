class CreateEventGroupes < ActiveRecord::Migration[7.0]
  def change
    create_table :event_groupes do |t|
      t.integer :max_count
      t.string :status

      t.timestamps
    end
  end
end
