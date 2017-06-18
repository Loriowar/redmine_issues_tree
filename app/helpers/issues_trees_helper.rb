module IssuesTreesHelper
  def link_to_plain_view
    link_to l(:back_to_plain_list, scope: 'issues_tree'),
            {controller: :issues,
             skip_issues_tree_redirect: true},
            class: 'icon icon-plane-list'
  end
end
