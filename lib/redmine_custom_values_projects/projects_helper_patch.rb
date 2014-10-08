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

require_dependency 'projects_helper'

module RedmineCustomValuesProjects
  module ProjectsHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :project_settings_tabs, :custom_fields_project
      end
    end

    module InstanceMethods
      def project_settings_tabs_with_custom_fields_project
        tabs = project_settings_tabs_without_custom_fields_project
        tabs << {:name => 'possible_value_projects', :action => :manage_possible_values, :partial => 'projects/settings/possible_value_projects',
                 :label => :possible_value_project} if User.current.allowed_to?(:manage_possible_values, @project)
        tabs
      end
    end
  end
end


Rails.configuration.to_prepare do
  unless ProjectsHelper.included_modules.include?(RedmineCustomValuesProjects::ProjectsHelperPatch)
    ProjectsHelper.send(:include, RedmineCustomValuesProjects::ProjectsHelperPatch)
  end
end
