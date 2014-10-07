class PossibleValueProjectsController < ApplicationController
  unloadable

  before_filter :find_project, :authorize
  
  menu_item :settings

  def manage
    @custom_field = CustomField.find(params[:custom_field_id])    
    if request.post?
      customized_value = CustomFieldProjectValues.find_or_create_by_project_id_and_custom_field_id(@project.id, @custom_field.id)
      customized_value.values = params[:values]
      customized_value.save
      flash[:notice] = l(:notice_successful_update)
    end

    @possible_values = CustomFieldProjectValues.find_possible_values(@project.id, @custom_field.id)    
  end
end
