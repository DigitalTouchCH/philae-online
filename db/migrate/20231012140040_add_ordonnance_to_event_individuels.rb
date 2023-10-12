class AddOrdonnanceToEventIndividuels < ActiveRecord::Migration[7.0]
  def change
    add_reference :event_individuels, :ordonnance, null: false, foreign_key: true
  end
end
