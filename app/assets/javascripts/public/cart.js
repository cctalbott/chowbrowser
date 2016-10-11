function show_delivery_address() {
  if($("#cart_delivers").val() === "true") {
    $("#delivery_address_fields").css({"display": "block"});

    if(restaurant_to_delivery_distance > 11) {
      $("input:submit").attr("disabled", true);
    }
  } else {
    $("#delivery_address_fields").css({"display": "none"});

    if($("input:submit").attr("disabled")) {
      $("input:submit").attr("disabled", false);
    }
  }
}

function select_delivery_address(delivery_address) {
  $("#cart_delivery_address_attributes_address").val(delivery_address.address);
  $("#cart_delivery_address_attributes_city").val(delivery_address.city);
  $("#cart_delivery_address_attributes_zip").val(delivery_address.zip);
}

function delivery_distance(distance) {
  var total_distance = 0;
  restaurant_to_delivery_distance =
    distance.rows[0].elements[1].distance.value;
  restaurant_to_delivery_distance =
    Math.ceil(restaurant_to_delivery_distance / 1609);
  var total_duration = 0;

  $.each(distance.rows[0].elements, function() {
    if(this.status === "OK") {
      total_distance += this.distance.value;
      total_duration += this.duration.value;
    }
  });
  total_duration = Math.ceil(total_duration / 60);

  if(restaurant_to_delivery_distance <= 11) {
    $("#delivery_distance").html("Distance from the restaurant to you is "+
      restaurant_to_delivery_distance +" mi. We estimate "+ total_duration +
      " min. from pickup to delivery.");

    if($("#cart_delivery_address_attributes_address").hasClass("input_alert"))
    {
      $("#cart_delivery_address_attributes_address").removeClass("input_alert");
    }

    if($("input:submit").attr("disabled")) {
      $("input:submit").attr("disabled", false);
    }

// UPDATE CARTS DELIVERY_DISTANCE AND DURATION
    $.post("/public/delivery_address_distance.json",
      {
        delivery_distance: restaurant_to_delivery_distance,
        delivery_duration: total_duration
      },
      function(data) {
        //
      },
      "jsonp"
    );
  } else {
    $("#delivery_distance").html("Distance from the restaurant to you is "+
      restaurant_to_delivery_distance +" mi. We limit delivery to within "+
      "11 mi. of the restaurant your order is being placed at. Please "+
      "choose a closer delivery address or pickup");

    if(!$("#cart_delivery_address_attributes_address").hasClass("input_alert"))
    {
      $("#cart_delivery_address_attributes_address").addClass("input_alert");
    }

    $("input:submit").attr("disabled", true);
  }

  //alert("total distance: "+ total_distance +", total duration: "+
  //  total_duration);
}

function get_distance() {
  lat_lon = $("#restaurant_location_lat_lon").val();
  address = $("#cart_delivery_address_attributes_address").val();

  $.getJSON(
    "/public/delivery_address_distance.json?lat_lon="+ lat_lon +"&address="+
    address,
    function(data) {
      delivery_distance(data);
    });
}

$(document).ready(function () {
// GOOGLE MAPS DISTANCE MATRIX VARS
  if($("input#restaurant_location_lat_lon")) {
    var lat_lon;
    var address;
    var city = $("#cart_delivery_address_attributes_city").val();
    var state = "TX";
    var zip = $("#cart_delivery_address_attributes_zip").val();
    var restaurant_to_delivery_distance;
  }

  $(".item_options").hide(function() {
    $(".show_options_button").html("show details");
  });

  $(".show_options_button").click(function() {
    if($(this).parent().parent().prev().css("display") === "none") {
      $(this).parent().parent().prev().show(function() {
        $(this).next().find("td a.show_options_button").html("hide details");
      });
    } else {
      $(this).parent().parent().prev().hide(function() {
        $(this).next().find("td a.show_options_button").html("show details");
      });
    }
  });

  $("#plus_delivery").css({"display": "none"});

  $("#cart_delivers").change(function() {
    if($(this).val() === "false") {
      $("#plus_delivery").css({"display": "none"});
    } else {
      $("#plus_delivery").css({"display": "inline"});
    }
  });

  show_delivery_address();

  $("#cart_delivers").change(function() {
    show_delivery_address();
  });

  if($("input#restaurant_location_lat_lon")) {
// PREVIOUS DELIVERY SELECT
    $.getJSON("/public/delivery_address/"+ $('#previous_delivery').val() +
      ".json", function(data) {
        select_delivery_address(data);
      });

    $("#previous_delivery").change(function() {
      $.getJSON("/public/delivery_address/"+ $(this).val() +".json",
        function(data) {
          select_delivery_address(data);
        });
    });

    if($("#cart_delivery_address_attributes_address").val()) {
      get_distance();
    }

    $("#cart_delivery_address_attributes_address").change(function() {
      get_distance();
    });
  }
});
