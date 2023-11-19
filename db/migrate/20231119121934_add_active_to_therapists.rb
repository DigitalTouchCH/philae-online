class AddActiveToTherapists < ActiveRecord::Migration[7.0]
  def change
    add_column :therapists, :is_active, :boolean, default: true
  end
end
