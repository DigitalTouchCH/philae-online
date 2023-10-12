class AddEquipementToTimeBlocks < ActiveRecord::Migration[7.0]
  def change
    add_reference :time_blocks, :equipement, null: false, foreign_key: true
  end
end
