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