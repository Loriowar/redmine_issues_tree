module RedmineIssuesTree::IssuesHelperPatch
  extend ActiveSupport::Concern

  included do
    def link_to_redirect_to_tree_view
      link_to l(:tree_view, scope: 'issues_tree'), '#',
              onclick: 'ajaxRedirectToTree()',
              class: 'icon icon-orange-tree'
    end
  end

end


