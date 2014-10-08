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

require 'redmine'

require 'redmine_custom_values_projects/field_format_patch'
require 'redmine_custom_values_projects/projects_helper_patch'
require 'redmine_custom_values_projects/project_patch'

Redmine::Plugin.register :redmine_custom_values_projects do
  name 'Atis Custom Fields plugin'
  author 'Francisco Javier Pérez Ferrer'
  description 'This plugin allows to limit the values of custom fields (lists and checkboxes) per project'
  version '0.0.1'
  url 'https://github.com/javiferrer/redmine_custom_values_projects'
  author_url 'http://twitter.com/javiferrer'
  
  requires_redmine :version_or_higher => '2.5.0'
  
  permission :manage_possible_values, {:possible_value_projects => [:manage, :destroy]}, :require => :member
end
