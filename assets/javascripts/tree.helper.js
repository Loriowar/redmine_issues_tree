$( document ).ready(function() {
  $(".issues-tree-view-link").on('click', function(e) {
    e.preventDefault();

    selectAllOptions("selected_columns");

    $.ajax({
      type: "POST",
      url: $(e.target).data('linkToTreeView'),
      data: jQuery('#query_form').serialize(),
      dataType: "json",
      success: function (data, textStatus) {
        if (data.redirect) {
          // data.redirect contains the string URL to redirect to
          window.location.href = data.redirect;
        }
      }
    });
  });

  function selectAllOptions(id) {
    var $select = $('#'+id);
    $select.children('option').attr('selected', true);
  }
});