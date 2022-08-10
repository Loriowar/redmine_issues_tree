
plugin_name = :redmine_issues_tree
plugin_root = File.dirname(__FILE__)

if Rails.version < '6.0' || !Rails.autoloaders.zeitwerk_enabled?
  require_dependency plugin_root + '/lib/redmine_issues_tree/hook_listener'
end

Redmine::Plugin.register plugin_name do
  name 'Redmine Issues Tree plugin'
  author 'Ivan Zabrovskiy'
  description 'Provides a tree view of the issues list'
  version RedmineIssuesTree::Version::VERSION
  url 'https://github.com/Loriowar/redmine_issues_tree'
  author_url 'https://loriowar.com/about'

  settings partial: 'settings/redmine_issues_tree',
           default: {
             'default_redirect_to_tree_view' => 'false',
             'default_redirect_to_tree_view_without_project' => 'false'
           }
end

def patch_init
  prepend_patches_map =
    {
      ::RedmineIssuesTree::IssuesControllerPatch => ::IssuesController
    }
  prepend_patches_map.each_pair do |patch, target|
    target.send(:prepend, patch) unless target.included_modules.include?(patch)
  end

  include_patch_map =
    {
      ::RedmineIssuesTree::IssuesHelperPatch => ::IssuesHelper
    }
  include_patch_map.each_pair do |patch, target|
    target.send(:include, patch) unless target.included_modules.include?(patch)
  end
end

if Rails.version > '6.0' && Rails.autoloaders.zeitwerk_enabled?
  Rails.application.config.after_initialize do
    patch_init
  end
else
  Rails.configuration.to_prepare do
    patch_init
  end
end

# Assign permissions on a tree_view actions. Permissions is same as for :view_issues.
# Doesn't work without :find_optional_project filter in controller.
Redmine::AccessControl.
    permissions.
    find { |permission| permission.name == :view_issues }.
    actions.
    push('issues_trees/tree_index').
    push('issues_trees/redirect_with_params').
    push('issues_trees/tree_children')
