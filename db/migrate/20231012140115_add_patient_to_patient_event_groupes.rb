class AddPatientToPatientEventGroupes < ActiveRecord::Migration[7.0]
  def change
    add_reference :patient_event_groupes, :patient, null: false, foreign_key: true
  end
end
