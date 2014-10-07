class CustomFieldProjectValues < ActiveRecord::Base
  unloadable
  
  belongs_to :custom_field
  
  serialize :values
  
  
  def self.find_possible_values(project, custom_field)
    cf = self.find_by_project_id_and_custom_field_id(project, custom_field)
    
    if cf
      cf.possible_values
    else
      []
    end
  end
  
  def possible_values
    values = read_attribute(:values)
    if values.is_a?(Array)
      values.each do |value|
        value.force_encoding('UTF-8') if value.respond_to?(:force_encoding)
      end
      values
    else
      []
    end
  end
end
