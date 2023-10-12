class AddTherapistToTherapistServices < ActiveRecord::Migration[7.0]
  def change
    add_reference :therapist_services, :therapist, null: false, foreign_key: true
  end
end
