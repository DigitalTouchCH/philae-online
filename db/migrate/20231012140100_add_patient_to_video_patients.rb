class AddPatientToVideoPatients < ActiveRecord::Migration[7.0]
  def change
    add_reference :video_patients, :patient, null: false, foreign_key: true
  end
end
