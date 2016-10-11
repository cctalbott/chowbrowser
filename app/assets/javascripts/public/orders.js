//= require jquery.tools.min.js
//= require fancybox

$(document).ready(function() {
  var browserWidth = $(window).width();
  var year = $("#order_year").val() ? $("#order_year").val() : "all";
  var month = $("#order_month").val() ? $("#order_month").val() : "all";
  var day = $("#order_day").val() ? $("#order_day").val() : "all";
  var category = $("#order_category").val() ? $("#order_category").val() : "all";
  var restaurant = $("#order_restaurant").val() ? "/" + $("#order_restaurant").val() : "";
  var customer = $("#order_customer").val() ? "/" + $("#order_customer").val() : "";
  // google maps distance matrix vars
  /*var lat_lon;
  var address;
  var city = $("#cart_delivery_address_attributes_city").val();
  var state = "TX";
  var zip = $("#cart_delivery_address_attributes_zip").val();*/


  $("#order_year").change(function() {
    year = $(this).val() ? $(this).val() : "all";
    window.location.replace("/public/orders/"+ year +"/all/all/" + category + restaurant + customer);
  });
  $("#order_month").change(function() {
    month = $(this).val() ? $(this).val() : "all";
    window.location.replace("/public/orders/"+ year +"/"+ month + "/all/" + category + restaurant + customer);
  });
  $("#order_day").change(function() {
    day = $(this).val() ? $(this).val() : "all";
    window.location.replace("/public/orders/"+ year +"/"+ month +"/"+ day +"/"+ category + restaurant + customer);
  });
  $("#order_category").change(function() {
    category = $(this).val() ? $(this).val() : "all";
    window.location.replace("/public/orders/"+ year +"/"+ month +"/"+ day +"/"+ category);
  });
  $("#order_restaurant").change(function() {
    restaurant = "/" + $(this).val();
    window.location.replace("/public/orders/"+ year +"/"+ month +"/"+ day +"/"+ category + restaurant);
  });
  $("#order_customer").change(function() {
    customer = "/" + $(this).val();
    window.location.replace("/public/orders/"+ year +"/"+ month +"/"+ day +"/"+ category + customer);
  });

  // LIGHTBOX \\

  $("a.overlay_trigger").fancybox({
		ajax: {
      type: "GET"
		},
		type: 'ajax'
	});

	/*var faye = new Faye.Client(''+ window.location +':9292/faye');
  faye.subscribe('/orders/status_update', function (data) {
    alert(data);
  });*/

/*
  show_delivery_address();
  $("#cart_delivers").change(function() {
    show_delivery_address();
  })

  if($("input#restaurant_location_lat_lon")) {
    // PREVIOUS DELIVERY SELECT \\

    $.getJSON("/public/delivery_address/"+ $('#previous_delivery').val() +".json", function(data) {
      select_delivery_address(data);
    });

    $("#previous_delivery").change(function() {
      $.getJSON("/public/delivery_address/"+ $(this).val() +".json", function(data) {
        select_delivery_address(data);
      });
    });

    get_distance();
    $("#cart_delivery_address_attributes_address").change(function() {
      //address = $("#cart_delivery_address_attributes_address").val();
      get_distance();
    });
  }
*/
});
/*
function show_delivery_address() {
  if($("#cart_delivers").val() == "true") {
    $("#delivery_address_fields").css({"display": "block"});
  } else {
    $("#delivery_address_fields").css({"display": "none"});
  }
}

function select_delivery_address(delivery_address) {
  $("#cart_delivery_address_attributes_address").val(delivery_address.address);
  $("#cart_delivery_address_attributes_city").val(delivery_address.city);
  $("#cart_delivery_address_attributes_zip").val(delivery_address.zip);
}

function get_distance() {
  lat_lon = $("#restaurant_location_lat_lon").val();
  address = $("#cart_delivery_address_attributes_address").val();
  $.getJSON(
    "/public/delivery_address_distance.json?lat_lon="+ lat_lon +"&address="+ address +"",
    function(data) {
      delivery_distance(data);
    });
}

function delivery_distance(distance) {
  var total_distance = 0;
  var restaurant_to_delivery_distance = distance.rows[0].elements[1].distance.value;
  restaurant_to_delivery_distance = Math.ceil(restaurant_to_delivery_distance / 1609);
  var total_duration = 0;
  $.each(distance.rows[0].elements, function() {
    if(this.status == "OK") {
      total_distance += this.distance.value;
      total_duration += this.duration.value;
    }
  });
  total_duration = Math.ceil(total_duration / 60);
  $("#delivery_distance").html("Distance from the restaurant to you is "+ restaurant_to_delivery_distance +" mi. We estimate "+ total_duration +" min. from pickup to delivery.");
  //alert("total distance: "+ total_distance +", total duration: "+ total_duration);
}
*/
