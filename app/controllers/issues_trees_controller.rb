class IssuesTreesController < ApplicationController
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper
  helper :issues

  menu_item :issues, only: :tree_index

  # This filter, additionally, checks permissions in a project
  before_filter :find_optional_project, only: [:tree_index, :tree_children, :redirect_with_params]

  # Action for the issues tree view
  def tree_index
    retrieve_query

    # group operation is prohibited for the tree view; filling a warning message
    if @query.group_by.present?
      flash[:error] = l(:unable_to_group_in_tree_view, scope: 'issues_tree.errors')
      @query.group_by = nil
    end

    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a

    query_params = params.reject{|k, _| [:action, :controller, :utf8].include?(k.to_sym)}
    # template for substitute in js due to absence path-helper in it
    issue_id_template = ':issue_id:'

    url_for_load_tree_children =
        if @project.present?
          tree_children_project_issues_tree_path(project_id: @project.identifier,
                                                 id: issue_id_template)
        else
          tree_children_issues_tree_path(id: issue_id_template)
        end

    # put into data-attributes number of column with tree; +1 due to a column with checkboxes
    # additionally put an url for retrieve a children for issues
    @tree_data = { treetable_column_number: (@query.columns.index{|col| col.name == :subject} || 0) + 1,
                   url_for_load_tree_children: url_for_load_tree_children,
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
    # merge for proper work of retrieve_query
    params.merge!(params[:query_params])

    retrieve_query

    # group action is incompatible with tree view, so remove group_by option
    @query.group_by = nil if @query.group_by.present?

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
    if @project.present?
      render json: {redirect: tree_index_project_issues_trees_path(params_for_redirect)}
    else
      render json: {redirect: tree_index_issues_trees_path(params_for_redirect)}
    end
  end
end
