class RedmineIssuesTree::HookListener < Redmine::Hook::ViewListener
  render_on :view_issues_index_header,
            partial: 'issues_trees/issues_index_header_tags'
  render_on :view_issues_index_contextual,
            partial: 'issues_trees/link_to_tree_view'
  render_on :view_issues_tree_index_contextual,
            partial: 'issues_trees/link_to_plain_view'
end