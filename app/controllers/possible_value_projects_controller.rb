# "Custom values per project" redmine plugin
#
# Copyright (C) 2014   Francisco Javier Pérez Ferrer <contacto@javiferrer.es>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class PossibleValueProjectsController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :load_custom_field_project_values
  
  menu_item :settings

  def manage        
    if request.post?     
      @custom_field_project_values.values = params[:values]
      @custom_field_project_values.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to settings_project_path(@project, :tab => 'possible_value_projects')
    end
    
    @possible_values = @custom_field_project_values.values
    not_present_values = @possible_values - @custom_field.possible_values
    if not_present_values.any?
      flash[:error] = l(:error_values_not_available, :values => not_present_values.join(', '))
    end    
  end
  
  def destroy
    begin
      @custom_field_project_values.destroy
      flash[:notice] = l(:notice_successful_delete)
    rescue
      flash[:error] = l(:error_can_not_delete_field_project_values)
    end
    redirect_to settings_project_path(:tab => 'possible_value_projects')    
  end
  
  private
  def load_custom_field_project_values
    @custom_field = CustomField.find(params[:custom_field_id])
    @custom_field_project_values = CustomFieldProjectValue.find_or_initialize_by_project_id_and_custom_field_id(@project.id, @custom_field.id)
  end
end
