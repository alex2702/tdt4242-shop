# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# this code will populate the hidden expiry field that will contain the entire expiry date
# it takes the single values from the two separate fields for month/year
$(document).on "turbolinks:load", ->
  set_fields = ->
    $("#order_credit_card_expiry").val("01-" + $("#credit_card_expiry_month").val() + "-" + $("#credit_card_expiry_year").val())

  set_fields()

  $("#credit_card_expiry_month").change ->
    set_fields()

  $("#credit_card_expiry_year").change ->
    set_fields()

  $('[data-toggle="tooltip"]').tooltip()