module RedmineIssuesTree::IssuesControllerPatch
  extend ActiveSupport::Concern

  included do
    alias_method_chain :index, :redmine_issues_tree
  end

  def index_with_redmine_issues_tree
    skip_issues_tree_redirect = params.delete(:skip_issues_tree_redirect)

    if params[:project_id].present?
      if Setting.plugin_redmine_issues_tree.with_indifferent_access[:default_redirect_to_tree_view] == 'true'
        # @note: add additional parameter into all links on issues#index looks not so good as parsing a referer
        # @reason: we must prevent redirect to the tree_view if we do some actions on a plain view
        if skip_issues_tree_redirect == 'true' || URI(request.referer).path == project_issues_path
          index_without_redmine_issues_tree
        else
          redirect_to tree_index_project_issues_trees_path(request.query_parameters)
        end
      else
        index_without_redmine_issues_tree
      end
    else
      if Setting.plugin_redmine_issues_tree.with_indifferent_access[:default_redirect_to_tree_view_without_project] == 'true'
        # @note: add additional parameter into all links on issues#index looks not so good as parsing a referer
        # @reason: we must prevent redirect to the tree_view if we do some actions on a plain view
        if skip_issues_tree_redirect == 'true' || URI(request.referer).path == issues_path
          index_without_redmine_issues_tree
        else
          redirect_to tree_index_issues_trees_path(request.query_parameters)
        end
      else
        index_without_redmine_issues_tree
      end
    end
  end

  module ClassMethods
    # stub
  end
end
