$( document ).ready(function() {
  var table = $("#issues-tree");

  table.treetable({
    column: gon.treetable_column_number,
    expandable: true,
    onNodeCollapse: function() {
      var node = this;
      table.treetable("unloadBranch", node);
    },
    onNodeExpand: function() {
      var node = this;

      // Render loader/spinner while loading
      $.ajax({
        async: false, // Must be false, otherwise loadBranch happens after showChildren?
        url: gon.url_for_load_tree_children + node.id + gon.action_for_load_tree_children,
        data: {query_params: gon.query_params}
      }).done(function(html) {
        var rows = $(html).filter("tr");

        table.treetable("loadBranch", node, rows);
      });
    }
  });
});