require_dependency 'redmine_issues_tree/hook_listener'

plugin_name = :redmine_issues_tree

Redmine::Plugin.register plugin_name do
  name 'Redmine Issues Tree plugin'
  author 'Ivan Zabrovskiy'
  description 'Provides a tree view of the issues list'
  version RedmineIssuesTree::VERSION
  url 'https://github.com/Loriowar/redmine_issues_tree'
  author_url 'https://github.com/Loriowar'
end

Rails.configuration.to_prepare do
  require_patch plugin_name, %w(issue issues_helper)
end