class AddTherapistToEventIndividuels < ActiveRecord::Migration[7.0]
  def change
    add_reference :event_individuels, :therapist, null: false, foreign_key: true
  end
end
