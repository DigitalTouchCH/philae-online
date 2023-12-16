class ChangeUserIdNullInTherapists < ActiveRecord::Migration[7.0]
  def change
    change_column_null :therapists, :user_id, true
  end
end
