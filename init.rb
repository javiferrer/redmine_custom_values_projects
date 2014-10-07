require 'redmine'

require 'redmine_custom_values_projects/field_format_patch'
require 'redmine_custom_values_projects/projects_helper_patch'

Redmine::Plugin.register :redmine_custom_values_projects do
  name 'Atis Custom Fields plugin'
  author 'Francisco Javier Pérez Ferrer'
  description 'This plugin allows to limit the values of custom fields (lists and checkboxes) per project'
  version '0.0.1'
  url 'https://github.com/javiferrer/redmine_custom_values_projects'
  author_url 'http://twitter.com/javiferrer'
  
  permission :manage_possible_values, {:possible_value_projects => [:manage]}, :require => :member
end
