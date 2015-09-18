DeviceParam = require "./controller/deviceParam"

spInit = ->
  ###
    DECLARE
  ###
  deviceParam = DeviceParam()

  # get ID
  query = window.location.search.substring 1

  # EVENT LISTENER
  deviceParam.listen "START", ->
    dartsDataStore.send
      user_id: user_id
      message: "start"

  deviceParam.listen "WALK", ->
    dartsDataStore.send
      user_id: user_id
      message: "walk"

  deviceParam.listen "ROTATE", ( heading )->
    dartsDataStore.send
      user_id: user_id
      message: "rotate"
      heading: heading

  # INIT
  $( ".wrapper" ).hide()
  $( ".wrapper-sp" ).show()

  if query == ""
    $( ".notice" ).html "まずはPCから<br>このサイトを開いてね！"
  else
    element = query.split "="
    user_id = decodeURIComponent element[ 1 ]
    deviceParam.exec()

    dartsDataStore.send
      user_id: user_id
      message: "init"

module.exports = spInit
