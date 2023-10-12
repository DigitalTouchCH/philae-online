class AddWeekAvailabilityToTimeBlocks < ActiveRecord::Migration[7.0]
  def change
    add_reference :time_blocks, :week_availability, null: false, foreign_key: true
  end
end
