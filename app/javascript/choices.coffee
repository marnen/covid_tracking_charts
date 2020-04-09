import Choices from 'choices.js'

document.addEventListener 'turbolinks:load', ->
  stateSelector = document.querySelector 'select#states'
  options =
    removeItemButton: true
  new Choices stateSelector, options
