(function(){
  $('#floating-selection-search-form').hide();
  $('.floating-selection-textarea').val('')
  $.ajax({
    url: '/wiki/reconstruct/' + findTheEnd() + findTheQueryString()
  }).success(function(data){
    $('#makeupedia-main-body').html(data.content);
    $('title').text($(data.title).text());
    if (findTheQueryString().length === 0){
      $("#content").on('mouseup touchend', function() {
       showForm();
      $('#find_text').val(getSelectedText());
      $('#killer-awesome-submit-button').on('click', function(e){
        e.preventDefault();
        makeReplacements();
        hideForm()
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
  return window.location.pathname.split('/').pop()
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


