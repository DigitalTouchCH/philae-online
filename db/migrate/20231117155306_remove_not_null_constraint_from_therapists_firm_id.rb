class RemoveNotNullConstraintFromTherapistsFirmId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :therapists, :firm_id, true
  end
end
