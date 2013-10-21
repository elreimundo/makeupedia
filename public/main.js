function getSelectedText() {
  var text = "";
  if (window.getSelection) {
    text = window.getSelection().toString();
  } else if (document.selection && document.selection.type != "Control") {
    text = document.selection.createRange().text;
  }
  return text;
}


$(function() {

  $('#content').on('mouseup', function(e) {
    var toReplace = getSelectedText();
    console.log(toReplace)
    $('#text-select').val(toReplace);
  })

});