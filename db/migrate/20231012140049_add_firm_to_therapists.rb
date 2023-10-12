class AddFirmToTherapists < ActiveRecord::Migration[7.0]
  def change
    add_reference :therapists, :firm, null: false, foreign_key: true
  end
end
