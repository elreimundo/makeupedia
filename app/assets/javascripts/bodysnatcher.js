function reconstruct(){
  var ending = window.location.pathname.split('/').pop()
  $.ajax({
    url: '/wiki/reconstruct/' + ending
  }).success(function(e,d){$(document).html(d)})
}