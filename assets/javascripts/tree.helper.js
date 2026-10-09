$( document ).ready(function() {
  $(".issues-tree-view-link").on('click', function(e) {
    e.preventDefault();

    jQuery("#selected_c option").prop('selected', true);

    $.ajax({
      type: "POST",
      // e.target is the svg or the label span the icon markup adds inside the
      // link, so the data attribute has to be read from the link itself.
      url: $(e.currentTarget).data('linkToTreeView'),
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
});
