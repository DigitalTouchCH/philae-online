class AddFieldsToTables < ActiveRecord::Migration[7.0]
  def change
    add_column :prescripteurs, :mail, :string
    add_column :ordonnances, :commentaire, :text
    add_column :patients, :commentaire, :text
    add_column :event_individuels, :commentaire, :text
    add_column :event_groupes, :commentaire, :text
  end
end
