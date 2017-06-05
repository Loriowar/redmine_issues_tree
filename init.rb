require_dependency 'redmine_issues_tree/hook_listener'

plugin_name = :redmine_issues_tree

Redmine::Plugin.register plugin_name do
  name 'Redmine Issues Tree plugin'
  author 'Ivan Zabrovskiy'
  description 'Provides a tree view of the issues list'
  version RedmineIssuesTree::VERSION
  url 'https://github.com/Loriowar/redmine_issues_tree'
  author_url 'https://github.com/Loriowar'

  settings partial: 'settings/redmine_issues_tree', default: { 'default_redirect_to_tree_view' => false }
end

Rails.configuration.to_prepare do
  require_patch plugin_name, %w(issue issues_helper issues_controller)
end

# Assign permissions on a tree_view actions. Permissions is same as for :view_issues.
# Doesn't work without :find_optional_project filter in controller.
Redmine::AccessControl.
    permissions.
    find{ |permission| permission.name == :view_issues }.
    actions.
    push('issues_trees/tree_index').
    push('issues_trees/redirect_with_params').
    push('issues_trees/tree_children')
