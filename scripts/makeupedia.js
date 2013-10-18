$(document).ready(addClickListener)

function addClickListener(){
	$('.pure-button').on('click', function(){ makeAJAXCall($('#uri').val(),$('#find').val(),$('#replace').val()) } )
}

function makeAJAXCall(url,textToReplace,replacementText){
	history.pushState(null,null,window.location)
	$.getJSON('http://anyorigin.com/get?url='+ url + '&callback=?')
	  .done(function(data){ 
	  	console.log(data.contents);
	  	displayTheNewPage(data.contents.replace(new RegExp(textToReplace,'gi'),replacementText));
	  })
}

function displayTheNewPage(data){
	$('body').html(data)
}

function failMessage(){
	alert('This call is failing.')
}
