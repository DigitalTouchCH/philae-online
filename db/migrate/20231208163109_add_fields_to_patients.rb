class AddFieldsToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :medical_history, :text
    add_column :patients, :consent_form, :string
    add_column :patients, :emergency_contact_name, :text
    add_column :patients, :emergency_contact_tel, :text
    add_column :patients, :discharge, :string
    add_column :patients, :privacy_acknowledgement, :string
  end
end
