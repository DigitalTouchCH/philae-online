class AddStartAndEndTimeToEventGroupes < ActiveRecord::Migration[7.0]
  def change
    add_column :event_groupes, :start_date_time, :datetime
    add_column :event_groupes, :end_date_time, :datetime
  end
end
