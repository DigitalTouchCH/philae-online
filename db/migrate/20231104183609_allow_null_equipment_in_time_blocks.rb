class AllowNullEquipmentInTimeBlocks < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:time_blocks, :equipement_id, true)
  end
end
