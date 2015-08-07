module RedmineIssuesTree::IssuePatch
  extend ActiveSupport::Concern

  included do
    # stub
  end

  def children_in_range?(ids_range)
    children.where(id: ids_range).any?
  end

  module ClassMethods
    # stub
  end
end
