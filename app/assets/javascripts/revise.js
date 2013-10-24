;
(function(){

  $('#floating-selection-search-form').hide();
  $('.floating-selection-textarea').val('')
  $.ajax({
    url: '/wiki/reconstruct/' + findTheEnd() + findTheQueryString()
  }).done(function(data){
    try{
    //Run some code here
      var content = data.content
      $('#makeupedia-main-body').html(content);
    }
    catch(err){
    //Handle errors here
    }
    $('title').text($(data.title).text());
    if (findTheQueryString().length === 0) {
      $("#makeupedia-main-body").on('mouseup touchend', function() {
      // $("#content").on('mouseup touchend', function() {
      $('#replace_text').val('');
       showForm();
      $('#find_text').val(getSelectedText());
      $('#killer-awesome-submit-button').on('vclick', function(e){
        e.preventDefault();
        makeReplacements();
        hideForm();
        $.post('/wikis', $('#second-form').serialize())
        })
      });
    }
  }).fail(function(){
    $('body').prepend('<div>Something went wrong. The page you are looking for is probably too big for us to handle. Sorry!</div>')
  })

})()

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
