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

class CustomFieldProjectValue < ActiveRecord::Base
  unloadable
  
  belongs_to :custom_field
  belongs_to :project
  
  serialize :values
  
  
  def self.find_possible_values(project, custom_field)
    cf = self.find_by_project_id_and_custom_field_id(project, custom_field)
    
    if cf
      cf.possible_values
    else
      []
    end
  end
  
  def valid_values
    values
  end
  
  def values
    read_attribute(:values).nil? ? [] : read_attribute(:values)
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
  
  def values=(arg)
    v = arg.nil? ? [] : arg
    write_attribute(:values, v)
  end
end
