# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#custom error message for amount selection of products
$(document).on "turbolinks:load", ->
  inputs = document.getElementsByClassName('amount-input')
  i = 0
  for value, index in inputs
    inputs[index].addEventListener 'invalid', ((e) ->
      if inputs[index].validity.rangeOverflow
        e.target.setCustomValidity 'We only have ' + inputs[index].max + ' items of this product in stock.'
    ), false
    inputs[index].addEventListener 'input', (e) ->
      e.target.setCustomValidity ''

  $('[data-toggle="tooltip"]').tooltip()