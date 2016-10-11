//= require jquery.tools.min.js
//= require fancybox

$(document).ready(function() {
  // VARIABLES
  var browserWidth = $(window).width();
  var browserHeight = $(window).height();
  var adjustedBrowserHeight = (browserHeight - 180);

  function tooltipTrigger() {
    $(".tooltip").css({"display": "none"});
    $(".trigger").tooltip({
      effect: 'fade',
      fadeOutSpeed: 100,
      predelay: 400
    });
    /*$(".trigger").off("mouseenter mouseleave");
    $(".trigger").on("mouseenter mouseleave", ".trigger", function(event) {
      $(this).nextUntil(".tooltip", ".tooltip").css({"display": "block"});
    });
    $(".trigger").tooltip({
      effect: 'fade',
      fadeOutSpeed: 100,
      predelay: 400
    });*/
  }

  // CART
  hidden = "no";
  $("#show_cart").click(function() {
    $("#current_cart section .current_order").slideToggle("slow", function() {
      if(hidden === "yes") {
        hidden = "no";
        $("#show_cart").html("Hide Your Current Order");
      } else {
        hidden = "yes";
        $("#show_cart").html("Show Your Current Order");
      }
    });
  });

  // TOOLTIP
  if(browserWidth >= 600) {
    tooltipTrigger();
  } else {
    //$(".trigger").off("mouseenter mouseleave");
    $(".tooltip").css({
      "display": "block",
      "position": "static",
      "opacity": "1"
    });
  }
  $(window).resize(function() {
    browserWidth = $(window).width();
    browserHeight = $(window).height();
    if(browserWidth >= 600) {
      tooltipTrigger();
    } else {
      //$(".trigger").off("mouseenter mouseleave");
      $(".tooltip").css({
        "display": "block",
        "position": "static",
        "opacity": "1"
      });
    }
  });

  // OVERLAY
  $(".item .name_description h3 a").fancybox({
    ajax: {
      type: "GET"
    },
    type: 'ajax',
    width: Math.floor((browserWidth * 0.70))
  });
});
