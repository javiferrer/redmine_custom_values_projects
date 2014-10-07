# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
RedmineApp::Application.routes.draw do
  match '/projects/:id/manage_possible_values/:custom_field_id', :to => 'possible_value_projects#manage', :as => 'manage_possible_values', :via => [:get, :post]
end