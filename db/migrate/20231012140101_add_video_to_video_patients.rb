class AddVideoToVideoPatients < ActiveRecord::Migration[7.0]
  def change
    add_reference :video_patients, :video, null: false, foreign_key: true
  end
end
