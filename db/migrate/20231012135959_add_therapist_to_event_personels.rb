class AddTherapistToEventPersonels < ActiveRecord::Migration[7.0]
  def change
    add_reference :event_personels, :therapist, null: false, foreign_key: true
  end
end
