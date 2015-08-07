class IssuesTreesController < ApplicationController
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper
  helper :issues

  # Метод для древовидного отображения задач
  def tree_index
    @project = Project.where(identifier: params[:project_id]).first
    # ругаемся о попытке группировки при древовидном отображении
    if params[:group_by].present?
      flash[:error] = l(:unable_to_group_in_tree_view, scope: 'issues_tree.errors')
    end
    # удаляем параметр группировки, так как он ломает всё дерево
    params.reject!{|k, _| k.to_sym == :group_by}

    retrieve_query
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a

    query_params = params.reject{|k, _| [:action, :controller, :utf8].include?(k.to_sym)}
    # передаём в javascript номер колонки, в которой должна быть иерархия дерева
    # и url для получения чилдов
    # +1 из-за колонки с чекбоксами
    gon.push(treetable_column_number: (@query.columns.index{|col| col.name == :subject} || 0) + 1,
             url_for_load_tree_children: "/projects/#{ @project.identifier}/issues_trees/",
             action_for_load_tree_children: '/tree_children',
             query_params: query_params)

    @issues_ids = @query.issues.collect(&:id)

    if @issues_ids.present?
      # выбираем корневые элементы в разрезе текущего запроса
      @issues = @query.issues(conditions: "issues.parent_id NOT IN (#{@issues_ids.join(', ')}) OR issues.parent_id IS NULL",
                              include: [:assigned_to, :tracker, :priority, :category, :fixed_version],
                              order: sort_clause)
    else
      @issues = []
    end
  end

  # Получение списка вложенных задач первого уровня
  def tree_children
    @project = Project.where(identifier: params[:project_id]).first

    # мерж параметров для правильной работы retrieve_query, коий ищет параметры только среди params
    params.merge!(params[:query_params])
    # удаляем параметр группировки, так как он ломает всё дерево
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

  # Метод для редиректа на правильный экшн вместе с пробросом параметров сериализованной формы
  def redirect_with_params
    params_for_redirect = params.reject{|k, _| [:action, :controller, :utf8].include?(k.to_sym)}
    render json: {redirect: url_for(controller: :issues_trees,
                                    action: :tree_index,
                                    params: params_for_redirect)}
  end
end