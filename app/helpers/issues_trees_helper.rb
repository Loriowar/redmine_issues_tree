module IssuesTreesHelper
  def link_to_plain_view(project = @project)
    if project.present?
      link_to l(:back_to_plain_list, scope: 'issues_tree'),
              {controller: :issues},
              class: 'icon icon-plane-list'
    end
  end
end