$(document).ready(function() {
  dismiss_notification();
});

function dismiss_notification() {
  $(".notice").css({ opacity: 0.7 });
  $(".alert").css({ opacity: 0.7 });
  if($(".notice").css("display") == "block") {
    $(".notice").delay(4000).fadeOut(1000);
  }
  if($(".alert").css("display") == "block") {
    $(".alert").delay(4000).fadeOut(1000);
  }
  $(".notice").click(function() {
    $(this).clearQueue().fadeOut(1000);
  });
  $(".alert").click(function() {
    $(this).clearQueue().fadeOut(1000);
  });
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
}

function equal_columns(columns) {
  var tallestcolumn = 0;
  columns.each(function() {
    $(this).css({"height": "auto"});
    currentHeight = $(this).height();
    if(currentHeight > tallestcolumn) {
      tallestcolumn = currentHeight;
    }
  });
  columns.height(tallestcolumn);
}
