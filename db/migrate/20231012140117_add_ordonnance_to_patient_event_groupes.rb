class AddOrdonnanceToPatientEventGroupes < ActiveRecord::Migration[7.0]
  def change
    add_reference :patient_event_groupes, :ordonnance, null: false, foreign_key: true
  end
end
