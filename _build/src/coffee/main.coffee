###!
  * Main Function
###

window.$ = window.jQuery = require "jquery"
require "jquery.easing"

spInit = require "./spInit"
panoramaInit = require "./panoramaInit"
indexInit = require "./indexInit"

$ ->
  if window._DEBUG
    if Object.freeze?
      window.DEBUG = Object.freeze window._DEBUG
    else
      window.DEBUG = state: true
  else
    if Object.freeze?
      window.DEBUG = Object.freeze state: false
    else
      window.DEBUG = state: false

  ###
    DECLARE
  ###
  window.milkcocoa = new window.MilkCocoa "iceia90idbv.mlkcca.com"
  window.dartsDataStore = milkcocoa.dataStore "darts"

  ###
    INIT
  ###
  path = window.location.pathname
  if isSp()
    spInit()
  else if path.match "panorama"
    panoramaInit()
  else
    indexInit()

window.isAndroid = ->
  return window.navigator.userAgent.
         toLowerCase().match /android/

window.isSp = ->
  return window.navigator.userAgent.
         toLowerCase().match /android|ipad|iphone|ipad/
