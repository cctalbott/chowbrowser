var delivery_string = "<span id='deliver_fields'><label for='location_delivery_attributes_fee'>Delivery fee</label><input name='location[delivery_attributes][fee]' type='text' /></span>";
$(document).ready(function() {
  if($("#location_delivers").is(":checked")) {
    $("#location_delivers").parent().append(delivery_string);
  }

  $("#location_delivers").change(function() {
    if($(this).is(":checked")) {
      $(this).parent().append(delivery_string);
    } else {
      $("#deliver_fields").remove();
    }
  });
});
