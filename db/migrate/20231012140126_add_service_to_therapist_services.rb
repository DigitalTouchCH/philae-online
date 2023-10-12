class AddServiceToTherapistServices < ActiveRecord::Migration[7.0]
  def change
    add_reference :therapist_services, :service, null: false, foreign_key: true
  end
end
