require_dependency 'redmine_issues_tree/hook_listener'

plugin_name = :redmine_issues_tree

Redmine::Plugin.register plugin_name do
  name 'Redmine Issues Tree plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version RedmineIssuesTree::VERSION
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

Rails.configuration.to_prepare do
  require_patch plugin_name, %w(issue issues_helper)
end