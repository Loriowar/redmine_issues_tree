module IssuesTreesHelper
  def link_to_plain_view
    link_to sprite_icon('list', l(:back_to_plain_list, scope: 'issues_tree')),
            {controller: :issues,
             skip_issues_tree_redirect: true},
            class: 'icon icon-plane-list'
  end

  # Splits the root issues of the tree into consecutive groups.
  #
  # Grouping in the tree view follows an inheritance rule: a subtree always
  # belongs to the group of its root issue, whatever value its children carry
  # for the grouped column. Since IssuesTreesController#tree_index orders the
  # roots by the query's group_by_sort_order, issues of the same group are
  # already consecutive here.
  #
  # Returns an array of [group_name, group_count, issues] triples. group_name
  # is nil when the query is not grouped, which renders the plain single-table
  # tree.
  def tree_root_groups(roots, query, counts = {})
    return [[nil, nil, roots]] unless query.grouped?

    column = query.group_by_column

    roots.chunk_while {|a, b| column.group_value(a) == column.group_value(b)}.map do |group_issues|
      group = column.group_value(group_issues.first)

      name =
        if group.blank? && group != false
          "(#{l(:label_blank_value)})"
        else
          format_object(group)
        end

      [name || '', counts[group], group_issues]
    end
  end
end
