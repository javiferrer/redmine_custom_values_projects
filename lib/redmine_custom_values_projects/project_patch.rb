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

require_dependency 'project'

module RedmineCustomValuesProjects
  module ProjectPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        has_many :custom_field_project_values
      end
    end
  end
  
  module InstanceMethods
    
    def custom_fields_customized
      custom_field_project_values.collect {|c| c.custom_field}
    end
    
  end
end

Rails.configuration.to_prepare do
  unless Project.included_modules.include?(RedmineCustomValuesProjects::ProjectPatch)
    Project.send(:include, RedmineCustomValuesProjects::ProjectPatch)
  end
end
