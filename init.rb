plugin_name = :redmine_issues_tree

Redmine::Plugin.register plugin_name do
  name 'Redmine Issues Tree plugin'
  author 'Ivan Zabrovskiy'
  description 'Please, use proper branch of the plugin instead of master! Provides a tree view of the issues list. '
  version RedmineIssuesTree::VERSION
  url 'https://github.com/Loriowar/redmine_issues_tree'
  author_url 'https://github.com/Loriowar'
end
