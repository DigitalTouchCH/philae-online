class AddLocationToRooms < ActiveRecord::Migration[7.0]
  def change
    add_reference :rooms, :location, null: false, foreign_key: true
  end
end
