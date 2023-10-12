class AddEventGroupeToPatientEventGroupes < ActiveRecord::Migration[7.0]
  def change
    add_reference :patient_event_groupes, :event_groupe, null: false, foreign_key: true
  end
end
