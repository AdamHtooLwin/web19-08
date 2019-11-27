# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#search_user').tokenInput '/get_users.json', crossDomain: false;

$ ->
  $('.best_in_place').best_in_place();
