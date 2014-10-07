require 'redmine'

require 'redmine_custom_values_projects/field_format_patch'
require 'redmine_custom_values_projects/projects_helper_patch'

Redmine::Plugin.register :redmine_custom_values_projects do
  name 'Atis Custom Fields plugin'
  author 'Francisco Javier Pérez Ferrer'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/javiferrer/redmine_custom_values_projectsn'
  author_url 'http://twitter.com/javiferrer'
  
  
  project_module :redmine_custom_values_projects do
    permission :manage_possible_values, 
      {:possible_value_projects => [:manage]}, :require => :member
  end  
end
