$(function() {
  $( ".expand" ).click( function() {
    $( ".amendments" ).slideToggle("slow").show();
    $(this).toggleClass("selected");
  });
});