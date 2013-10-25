;
(function(){
  hideAndClearTheForm();
  $.ajax({
    url: '/wiki/reconstruct/' + findTheEnd() + findTheQueryString()
  }).done(reconstructThePage).fail(weFail)
})()

function reconstructThePage(data){
  try{
    var content = data.content
    $('#makeupedia-main-body').html(content);
  }
  catch(err){
  }
  changeToOurTitle($(data.title).text());
  if (findTheQueryString().length === 0) {
    attachFormListeners();
  }
}

function showFormWithReplaceCleared(){
  $('#replace_text').val('');
  showForm();
}

function changeToOurTitle(title){
  $('title').text(title);
}

function weFail(){
  $('body').prepend('Sorry. Something went wrong.')
}

function hideAndClearTheForm(){
  $('#floating-selection-search-form').hide();
  $('.floating-selection-textarea').val('')
}

function makeReplacements(){
  var findRegex = new RegExp($('#find_text').val(),'gim')
  var replaceIt = $('#replace_text').val();
  $('#content *').replaceText(findRegex, replaceIt);
}

function findTheEnd(){
  return capitalize(window.location.pathname.split('/').pop())
}

function findTheQueryString(){
  return window.location.search
}

function showForm(){
  $('#floating-selection-search-form').slideDown()
}

function hideForm(){
  $('#floating-selection-search-form').slideUp()
}

function getSelectedText() {
  var text = "";
  if (window.getSelection) {
    text = window.getSelection().toString();
  } else if (document.selection && document.selection.type != "Control") {
    text = document.selection.createRange().text;
  }
  return text;
}

function capitalize(string){
  return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
}

function attachFormListeners(){
  $("#makeupedia-main-body").on('mouseup touchend', function() {
    showFormWithReplaceCleared()
    $('#find_text').val(getSelectedText());
    $('#hide-form-button').on('vclick', function(e) {
      e.stopPropagation();
      hideForm();
    })
    $('#killer-awesome-submit-button').on('vclick', function(e){
      e.preventDefault();
      makeReplacements();
      hideForm();
      $.post('/wikis', $('#second-form').serialize())
    })
  });
}