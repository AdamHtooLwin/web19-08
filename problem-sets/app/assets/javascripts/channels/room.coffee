$(document).on 'turbolinks:load', ->
  $("#messages").scrollTop($("#messages")[0].scrollHeight);
  submit_message()

submit_message = () ->
  $('#message_content').on 'keydown', (event) ->
    if event.keyCode is 13
      $('input').click()
      event.target.value = ""
      event.preventDefault()



App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    console.log('Connected to room channel!')
    # Called when the subscription is ready for use on the server

  disconnected: ->
    console.log('Disconnected from room channel!')
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log('Got message from channel!')

    unless data.content.blank?
      $('#messages-table').append '<div class="message">' +
        '<div class="message-user">' + data.first_name + ":" + '</div>' +
        '<div class="message-content">' + data.content + '</div>' + '</div>'

    $("#messages").scrollTop($("#messages")[0].scrollHeight);
