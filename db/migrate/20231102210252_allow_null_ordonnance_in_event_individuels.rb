class AllowNullOrdonnanceInEventIndividuels < ActiveRecord::Migration[7.0]
  def change
    change_column_null :event_individuels, :ordonnance_id, true
  end
end
