module RedmineIssuesTree
  VERSION = '0.0.15'
end

require_relative 'redmine_issues_tree/hook_listener'
require_relative 'redmine_issues_tree/issues_helper_patch'
require_relative 'redmine_issues_tree/issues_controller_patch'
