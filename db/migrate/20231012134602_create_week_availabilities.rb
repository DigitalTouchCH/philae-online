class CreateWeekAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :week_availabilities do |t|
      t.date :valid_from
      t.date :valid_until
      t.text :name

      t.timestamps
    end
  end
end
