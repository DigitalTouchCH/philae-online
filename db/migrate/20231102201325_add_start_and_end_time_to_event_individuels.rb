class AddStartAndEndTimeToEventIndividuels < ActiveRecord::Migration[7.0]
  def change
    add_column :event_individuels, :start_date_time, :datetime
    add_column :event_individuels, :end_date_time, :datetime
  end
end
