class AllowNullUserIdInPatients < ActiveRecord::Migration[7.0]
  def change
    change_column_null :patients, :user_id, true
  end
end
