class CreateCustomFieldProjectValues < ActiveRecord::Migration
  def change
    create_table :custom_field_project_values do |t|
      t.integer :project_id
      t.integer :custom_field_id
      t.text :values
    end
  end
end
