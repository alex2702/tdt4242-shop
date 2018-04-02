# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  set_fields = ->
    if $("#status_select").val() is ""
      $("#status_text").addClass "hidden"
      $("#status_text").removeProp "required"
      $("#message_subject").prop "disabled", "disabled"
      $("#message_body").prop "disabled", "disabled"
      $("#message_new_status").val($("#status_select").val())
      $("#status_text").val("")
      $("#message_subject").val("")
      $("#message_body").val("")
    else if $("#status_select").val() is "other"
      $("#status_text").removeClass "hidden"
      $("#status_text").prop "required", "true"
      $("#message_subject").removeProp "disabled"
      $("#message_body").removeProp "disabled"
      $("#message_subject").val("")
      $("#message_body").val("")
      $("#message_new_status").val($("#status_text").val())
    else
      $("#status_text").addClass "hidden"
      $("#status_text").removeProp "required"
      $("#message_new_status").val($("#status_select").val())
      switch $("#status_select").val()
        when "Order Confirmed"
          $("#message_subject").val($("#subject_order_confirmed").val());
          $("#message_body").val($("#body_order_confirmed").val());
          $("#message_subject").prop "disabled", "disabled"
          $("#message_body").prop "disabled", "disabled"
        when "Payment Received"
          $("#message_subject").val($("#subject_payment_received").val());
          $("#message_body").val($("#body_payment_received").val());
          $("#message_subject").prop "disabled", "disabled"
          $("#message_body").prop "disabled", "disabled"
        when "Order Shipped"
          $("#message_subject").val($("#subject_order_shipped").val());
          $("#message_body").val($("#body_order_shipped").val());
          $("#message_subject").prop "disabled", "disabled"
          $("#message_body").prop "disabled", "disabled"

  set_fields()

  $("#status_select").change ->
    set_fields()

  $("#status_text").keyup ->
    set_fields()

  options =
    placement: (context, source) ->
      position = $(source).offset()
      if position.left > 260
        return 'right'
      'top'
    trigger: 'focus'
    container: 'body'

  $("#message_body").popover options
  $("#message_subject").popover options