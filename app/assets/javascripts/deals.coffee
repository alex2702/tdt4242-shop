# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  set_fields = ->
    if $("#deal_type").val() is "VolumeDeal"
      $(".volume-based-deal").removeClass "hidden"
      $(".percentage-based-deal").addClass "hidden"
      $(".volume-based-deal input").prop "required", "true"
    else if $("#deal_type").val() is "PercentageDeal"
      $(".volume-based-deal").addClass "hidden"
      $(".percentage-based-deal").removeClass "hidden"
      $(".volume-based-deal input").removeProp "required"
    else
      $(".volume-based-deal").addClass "hidden"
      $(".percentage-based-deal").addClass "hidden"
      $(".volume-based-deal input").removeProp "required"

  set_fields()

  $("#deal_type").change ->
    set_fields()

  # synchronize slider and text input fields for percentage
  $("#discount_percentage_text_").change ->
    $("#deal_discount_percentage").val($("#discount_percentage_text_").val())

  $("#deal_discount_percentage").change ->
    $("#discount_percentage_text_").val($("#deal_discount_percentage").val())

  # configure popovers for form field explanations
  options =
    placement: (context, source) ->
      position = $(source).offset()
      if position.left > 260
        return 'right'
      'top'
    trigger: 'focus'
    container: 'body'

  $("#deal_trigger_amount").popover options
  $("#deal_deal_amount").popover options