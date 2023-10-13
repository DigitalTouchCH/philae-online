class ModifyStartDateInEventPersonels < ActiveRecord::Migration[7.0]
  def change
    remove_column :event_personels, :start_date_time, :time
    add_column :event_personels, :start_date_time, :datetime
    remove_column :event_personels, :end_date_time, :time
    add_column :event_personels, :end_date_time, :datetime
  end
end
