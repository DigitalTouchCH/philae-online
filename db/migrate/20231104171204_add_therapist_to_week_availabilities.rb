class AddTherapistToWeekAvailabilities < ActiveRecord::Migration[7.0]
  def change
    add_reference :week_availabilities, :therapist, null: false, foreign_key: true
  end
end
