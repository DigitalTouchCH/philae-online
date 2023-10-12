class CreatePatientEventGroupes < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_event_groupes do |t|
      t.string :status

      t.timestamps
    end
  end
end
