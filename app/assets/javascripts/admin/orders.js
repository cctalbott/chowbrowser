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

  $("#order_year").change(function() {
    year = $(this).val() ? $(this).val() : "all";
    window.location.replace("/admin/orders/"+ year +"/all/all/" + category + restaurant + customer);
  });
  $("#order_month").change(function() {
    month = $(this).val() ? $(this).val() : "all";
    window.location.replace("/admin/orders/"+ year +"/"+ month + "/all/" + category + restaurant + customer);
  });
  $("#order_day").change(function() {
    day = $(this).val() ? $(this).val() : "all";
    window.location.replace("/admin/orders/"+ year +"/"+ month +"/"+ day +"/"+ category + restaurant + customer);
  });
  $("#order_category").change(function() {
    category = $(this).val() ? $(this).val() : "all";
    window.location.replace("/admin/orders/"+ year +"/"+ month +"/"+ day +"/"+ category);
  });
  $("#order_restaurant").change(function() {
    restaurant = "/" + $(this).val();
    window.location.replace("/admin/orders/"+ year +"/"+ month +"/"+ day +"/"+ category + restaurant);
  });
  $("#order_customer").change(function() {
    customer = "/" + $(this).val();
    window.location.replace("/admin/orders/"+ year +"/"+ month +"/"+ day +"/"+ category + customer);
  });

  // LIGHTBOX \\

  $("a.overlay_trigger").fancybox({
		ajax: {
      type: "GET"
		},
		type: 'ajax'
	});
});
