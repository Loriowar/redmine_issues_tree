class IssuesTreesController < ApplicationController
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper
  helper :issues

  # Action for the issues tree view
  def tree_index
    @project = Project.where(identifier: params[:project_id]).first
    # group operation is prohibited for the tree view; filling a warning message
    if params[:group_by].present?
      flash[:error] = l(:unable_to_group_in_tree_view, scope: 'issues_tree.errors')
    end
    # removing params for grouping
    params.reject!{|k, _| k.to_sym == :group_by}

    retrieve_query
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a

    query_params = params.reject{|k, _| [:action, :controller, :utf8].include?(k.to_sym)}
    # template for substitute in js due to absence path-helper in it
    issue_id_template = ':issue_id:'
    # put into data-attributes number of column with tree; +1 due to a column with checkboxes
    # additionally put an url for retrieve a children for issues
    @tree_data = { treetable_column_number: (@query.columns.index{|col| col.name == :subject} || 0) + 1,
                   url_for_load_tree_children: tree_children_project_issues_tree_path(project_id: @project.identifier,
                                                                                      id: issue_id_template),
                   issue_id_template: issue_id_template,
                   query_params: query_params }

    @issues_ids = @query.issues.collect(&:id)

    if @issues_ids.present?
      # selecting a root elements for a current query
      @issues = @query.issues(conditions: "issues.parent_id NOT IN (#{@issues_ids.join(', ')}) OR issues.parent_id IS NULL",
                              include: [:assigned_to, :tracker, :priority, :category, :fixed_version],
                              order: sort_clause)
    else
      @issues = []
    end
  end

  # Retrieve a first level of a nested (children) issues
  def tree_children
    @project = Project.where(identifier: params[:project_id]).first

    # merge for proper work of retrieve_query
    params.merge!(params[:query_params])
    # group action is incompatible with tree view, so removing group_by param
    params.reject!{|k, _| k.to_sym == :group_by}

    retrieve_query
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a

    @issues_ids = @query.issues.collect(&:id)

    @issues = @query.issues(conditions: "issues.parent_id = #{params[:id]}",
                            include: [:assigned_to, :tracker, :priority, :category, :fixed_version],
                            order: sort_clause)

    render layout: false
  end

  # Redirect with proper params from serialized form
  def redirect_with_params
    params_for_redirect = params.reject{|k, _| [:action, :controller, :utf8].include?(k.to_sym)}
    render json: {redirect: url_for(controller: :issues_trees,
                                    action: :tree_index,
                                    params: params_for_redirect)}
  end
end