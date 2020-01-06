module RedmineIssuesTree::IssuesControllerPatch
  def index
    if request.format.html?
      skip_issues_tree_redirect = params.delete(:skip_issues_tree_redirect)
      settings = Setting.plugin_redmine_issues_tree.to_h.with_indifferent_access

      if params[:project_id].present?
        if settings[:default_redirect_to_tree_view] == 'true'
          # @note: add additional parameter into all links on issues#index looks not so good as parsing a referer
          # @reason: we must prevent redirect to the tree_view if we do some actions on a plain view
          if skip_issues_tree_redirect == 'true' || URI(request.referer).path == project_issues_path
            super
          else
            redirect_to tree_index_project_issues_trees_path(request.query_parameters)
          end
        else
          super
        end
      else
        if settings[:default_redirect_to_tree_view_without_project] == 'true'
          # @note: add additional parameter into all links on issues#index looks not so good as parsing a referer
          # @reason: we must prevent redirect to the tree_view if we do some actions on a plain view
          if skip_issues_tree_redirect == 'true' || URI(request.referer).path == issues_path
            super
          else
            redirect_to tree_index_issues_trees_path(request.query_parameters)
          end
        else
          super
        end
      end
    else
      super
    end
  end

  module ClassMethods
    # stub
  end
end
