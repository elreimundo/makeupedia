// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function getSelectedText() {
  var text = "";
  if (window.getSelection) {
    text = window.getSelection().toString();
  } else if (document.selection && document.selection.type != "Control") {
    text = document.selection.createRange().text;
  }
  return text;
}

var MakeRequest = {
  init: function() {
    $('#main-form-submit').on('click', function(e){
      e.preventDefault();
      window.location = '/wiki/'+$('#search').val().split(' ').join('_');
    } )
    $('.all-changes').on('ajax:success', this.appendResponse);
  },

  appendResponse: function(event, data) {
    var newDoc = document.open("text/html", "replace");
    newDoc.write(data.content)
    $(newDoc).on('readystatechange', MakeRequest.bindListeners);
    newDoc.close();
  },

  bindListeners: function(e) {
    // 'this' is the document
    // when 'this.readyState === "complete"', you can bind your listener
    if (this.readyState === "complete") {

    }
  }
}

$(function() {
  MakeRequest.init();
});