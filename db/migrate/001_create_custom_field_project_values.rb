class CreateContactJournals < Rails.version < '5.2' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  def change
    create_table :custom_field_project_values do |t|
      t.integer :project_id
      t.integer :custom_field_id
      t.text :values
    end
  end
end
