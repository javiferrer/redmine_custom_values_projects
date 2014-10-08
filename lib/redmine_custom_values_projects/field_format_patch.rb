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

module RedmineCustomValuesProjects
  module FieldFormatPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        alias_method_chain :possible_custom_value_options, :custom_values_per_project
        alias_method_chain :possible_values_options, :custom_values_per_project
      end
    end
  
    module InstanceMethods 
      def possible_custom_value_options_with_custom_values_per_project(custom_value)
        options = possible_custom_values_options(custom_value)
        missing = [custom_value.value].flatten.reject(&:blank?) - options
        if missing.any?
          options += missing
        end
        options
      end
      
      def possible_values_options_with_custom_values_per_project(custom_field, object=nil)
        if object.is_a?(Project)
          load_possible_values(custom_field, object)
        elsif object.is_a?(Array)
          are_issues = (object.collect {|o| o.class.name}.uniq.first == 'Issue')
          if are_issues
            projects = object.collect {|o| o.project}.uniq
            if projects.size > 1
              values = []
              projects.each do |project|
                values << load_possible_values(custom_field, project)
              end
              values.flatten.uniq
            else
              load_possible_values(custom_field, projects.first)
            end
          else
            custom_field.possible_values
          end
        else
          custom_field.possible_values
        end
      end      
      
      def possible_custom_values_options(custom_value)
        #if custom_value.customized.methods.include?(:project)
        if custom_value.customized.is_a?(Issue)
          project = custom_value.customized.project
          load_possible_values(custom_value.custom_field, project)
        else
          custom_value.custom_field.possible_values
        end
      end
      
      def load_possible_values(custom_field, project=nil)
        if project.nil?
          custom_field.possible_values
        else
          custom_values = CustomFieldProjectValue.where(:project_id => project.id, :custom_field_id => custom_field.id).first
          custom_values.nil? ? custom_field.possible_values : custom_values.valid_values  
        end
      end     
    end
  end
end

Rails.configuration.to_prepare do
  unless Redmine::FieldFormat::ListFormat.included_modules.include?(RedmineCustomValuesProjects::FieldFormatPatch)
    Redmine::FieldFormat::ListFormat.send(:include, RedmineCustomValuesProjects::FieldFormatPatch)
  end
end
