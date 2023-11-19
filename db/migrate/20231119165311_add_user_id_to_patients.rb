class AddUserIdToPatients < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :patient, foreign_key: true
  end
end
