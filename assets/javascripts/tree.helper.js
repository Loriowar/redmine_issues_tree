$( document ).ready(function() {
  window.ajaxRedirectToTree = function() {
    selectAllOptions("selected_columns");

    $.ajax({
      type: "POST",
      url: 'issues_trees/redirect_with_params',
      data: jQuery('#query_form').serialize(),
      dataType: "json",
      success: function (data, textStatus) {
        if (data.redirect) {
          // data.redirect contains the string URL to redirect to
          window.location.href = data.redirect;
        }
      }
    });
  };

  function selectAllOptions(id) {
    var $select = $('#'+id);
    $select.children('option').attr('selected', true);
  }
});