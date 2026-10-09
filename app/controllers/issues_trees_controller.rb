class IssuesTreesController < ApplicationController
  helper :queries
  include QueriesHelper
  helper :issues
  helper :versions

  menu_item :issues, only: :tree_index

  # This filter, additionally, checks permissions in a project
  before_action :find_optional_project, only: [:tree_index, :tree_children, :redirect_with_params]

  # Action for the issues tree view
  def tree_index
    retrieve_default_query
    retrieve_query

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

    # Every issue matching the query, loaded once: it provides the ids used to
    # decide which issues are roots of the tree and, when the query is grouped,
    # the data the group counts are computed from.
    all_issues = @query.issues
    @issues_ids = all_issues.map(&:id)
    issues_by_id = all_issues.index_by(&:id)

    # Roots are the issues whose parent is not itself part of the result set.
    # When the query is grouped they come back ordered by group_by_sort_order,
    # so issues of the same group stay consecutive for the view.
    @issues = all_issues.select do |issue|
      issue.parent_id.nil? || !issues_by_id.key?(issue.parent_id)
    end

    @group_counts = @query.grouped? ? group_counts_by_root(all_issues, issues_by_id) : {}
  end

  # Retrieve a first level of a nested (children) issues
  def tree_children
    # merge for proper work of retrieve_query
    params.permit!.merge!(params[:query_params])

    retrieve_default_query
    retrieve_query

    # Children are rendered inside the group their root issue belongs to, so
    # the grouped ordering must not be applied to them: it would reorder the
    # children of a node by a value that does not decide their placement.
    @query.group_by = nil if @query.group_by.present?
    @issues_ids = @query.issues.collect(&:id)
    @issues = @query.issues(conditions: "issues.parent_id = #{params[:id]}")

    render layout: false
  end

  # Redirect with proper params from serialized form
  def redirect_with_params
    params_for_redirect = params.permit!.reject{|k, _| [:action, :controller, :utf8].include?(k.to_sym)}
    if @project.present?
      render json: {redirect: tree_index_project_issues_trees_path(params_for_redirect)}
    else
      render json: {redirect: tree_index_issues_trees_path(params_for_redirect)}
    end
  end

  private

  # IssuesController#index applies the configured default query (Query#is_default)
  # via this same check before calling retrieve_query, so a session-less request
  # lands on it. This controller does not inherit from IssuesController, so
  # without this call, retrieve_query falls straight to its own fallback -- a
  # brand new unsaved query unrelated to the default -- every time the session
  # does not already carry a query id (fresh browser, expired session). Mirrors
  # IssuesController#retrieve_default_query.
  def retrieve_default_query
    return if params[:query_id].present?
    return if params[:set_filter]

    if params[:without_default].present?
      params[:set_filter] = 1
      return
    end
    if session[:issue_query]
      query_id, project_id = session[:issue_query].values_at(:id, :project_id)
      return if query_id && project_id == @project&.id && IssueQuery.exists?(id: query_id)
    end
    if (default_query = IssueQuery.default(project: @project))
      params[:query_id] = default_query.id
    end
  end

  # Counts issues per group, applying the tree view's inheritance rule: an
  # issue is counted in the group of the topmost ancestor that still belongs to
  # the result set, which is the root of the subtree it is displayed under.
  #
  # This deliberately differs from Query#result_count_by_group, which counts
  # every issue under its own value and would therefore disagree with what the
  # tree actually shows.
  def group_counts_by_root(all_issues, issues_by_id)
    column = @query.group_by_column
    counts = Hash.new(0)

    all_issues.each do |issue|
      root = issue
      # Redmine forbids cycles in the issue hierarchy, but a corrupted nested
      # set would otherwise spin here forever.
      seen = Set.new([issue.id])
      while (parent = issues_by_id[root.parent_id]) && seen.add?(parent.id)
        root = parent
      end

      counts[column.group_value(root)] += 1
    end

    counts
  end
end
