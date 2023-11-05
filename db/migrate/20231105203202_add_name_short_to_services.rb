class AddNameShortToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :name_short, :string
  end
end
