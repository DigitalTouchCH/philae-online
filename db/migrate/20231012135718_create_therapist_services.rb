class CreateTherapistServices < ActiveRecord::Migration[7.0]
  def change
    create_table :therapist_services do |t|

      t.timestamps
    end
  end
end
