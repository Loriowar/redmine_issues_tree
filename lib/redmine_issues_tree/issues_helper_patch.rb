module RedmineIssuesTree::IssuesHelperPatch
  extend ActiveSupport::Concern

  included do
    def link_to_tree_view(project = @project)
      if project.present?
        link_to l(:tree_view, scope: 'issues_tree'), '#',
                class: 'icon icon-orange-tree issues-tree-view-link',
                data: {link_to_tree_view: redirect_with_params_project_issues_trees_path(project_id: project)}
      else
        link_to l(:tree_view, scope: 'issues_tree'), '#',
                class: 'icon icon-orange-tree issues-tree-view-link',
                data: {link_to_tree_view: redirect_with_params_issues_trees_path}
      end
    end
  end

end
