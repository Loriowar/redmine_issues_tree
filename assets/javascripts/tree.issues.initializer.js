// Expand/collapse a group of the tree view.
//
// Redmine's own toggleRowGroup() calls .toggle() on every row until the next
// group row, which would invert the rows treetable keeps hidden for collapsed
// branches. Each group owns a tbody instead, so toggling that single element
// hides the whole group and restores it with the branch states intact.
function toggleIssuesTreeGroup(el) {
  var $header = $(el).parents('tr').first();
  var $body = $header.closest('tbody').next('tbody.issues-tree-group-body');

  $header.toggleClass('open');
  $(el).toggleClass('icon-expanded icon-collapsed');

  if (typeof toggleExpendCollapseIcon === 'function') {
    toggleExpendCollapseIcon(el);
  }

  $body.toggle();
}

$( document ).ready(function() {
  var $table = $("#issues-tree");
  var $form = $(".issues-tree-index-form");

  $table.treetable({
    column: $form.data('treetableColumnNumber'),
    expandable: true,
    onNodeCollapse: function() {
      var node = this;
      $table.treetable("unloadBranch", node);
    },
    onNodeExpand: function() {
      var node = this;

      // Render loader/spinner while loading
      $.ajax({
        async: false, // Must be false, otherwise loadBranch happens after showChildren?
        url: $form.data('urlForLoadTreeChildren').replace($form.data('issueIdTemplate'), node.id),
        data: {query_params: $form.data('queryParams')}
      }).done(function(html) {
        var rows = $(html).filter("tr");

        $table.treetable("loadBranch", node, rows);
      });
    }
  });
});
