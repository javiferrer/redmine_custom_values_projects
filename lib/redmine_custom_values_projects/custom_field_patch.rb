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
  module CustomFieldPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        alias_method_chain :possible_values_options, :custom_values_per_project
      end
    end
  
    module InstanceMethods
      def possible_values_options_with_custom_values_per_project(obj=nil)
        case field_format
        when 'user', 'version'
          if obj.respond_to?(:project) && obj.project
            case field_format
            when 'user'
              obj.project.users.sort.collect {|u| [u.to_s, u.id.to_s]}
            when 'version'
              obj.project.shared_versions.sort.collect {|u| [u.to_s, u.id.to_s]}
            end
          elsif obj.is_a?(Array)
            obj.collect {|o| possible_values_custom(o)}.reduce(:&)
          else
            []
          end
        when 'bool'
          [[l(:general_text_Yes), '1'], [l(:general_text_No), '0']]
        else
          possible_values_custom(obj)
        end
      end
    
      def possible_values_custom(obj=nil)
        case field_format
        when 'user', 'version'
          possible_values_options(obj).collect(&:last)
        when 'bool'
          ['1', '0']
        else
          if obj.is_a?(Array)
              first_obj_valid = ['Issue', 'Project'].include?(obj.first.class.name)
              if first_obj_valid
                projects = obj.collect {|o| o.project}.uniq
                if projects.size > 1
                  values = []
                  projects.each do |project|
                    values << load_possible_values(project)
                  end
                  values.flatten.uniq
                else
                  load_possible_values(projects.first)
                end
              else
                possible_values
              end
          elsif (obj.is_a?(Issue) || obj.is_a?(Project))
            project = obj.project
            load_possible_values(project)        
          else
            possible_values 
          end      
        end
      end  
      
      def load_possible_values(project=nil)
        if project.nil?
          possible_values
        else
          custom_values = CustomFieldProjectValue.where(:project_id => project.id, :custom_field_id => self.id).first
          custom_values.nil? ? possible_values : custom_values.valid_values  
        end
      end      
    end
  end
end

Rails.configuration.to_prepare do
  unless CustomField.included_modules.include?(RedmineCustomValuesProjects::CustomFieldPatch)
    CustomField.send(:include, RedmineCustomValuesProjects::CustomFieldPatch)
  end
end
