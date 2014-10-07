require_dependency 'projects_helper'

module RedmineCustomValuesProjects
  module ProjectsHelperPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
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

ProjectsHelper.send(:include, RedmineCustomValuesProjects::ProjectsHelperPatch)