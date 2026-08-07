module RedmineIssuesTree
  module IssuesHelperPatch

    def self.included(base)
      base.class_eval do
        def link_to_tree_view(project = @project)
          path = if project.present?
                   redirect_with_params_project_issues_trees_path(project_id: project)
                 else
                   redirect_with_params_issues_trees_path
                 end

          link_to sprite_icon('tree', l(:tree_view, scope: 'issues_tree'), plugin: 'redmine_issues_tree'),
                  '#',
                  class: 'icon icon-orange-tree issues-tree-view-link',
                  data: {link_to_tree_view: path}
        end
      end
    end
  end
end

unless IssuesHelper.included_modules.include?(RedmineIssuesTree::IssuesHelperPatch)
  IssuesHelper.send(:include, RedmineIssuesTree::IssuesHelperPatch)
end
