class CreateEventPersonels < ActiveRecord::Migration[7.0]
  def change
    create_table :event_personels do |t|
      t.boolean :is_paid_holiday
      t.time :start_date_time
      t.time :end_date_time
      t.text :reason

      t.timestamps
    end
  end
end
