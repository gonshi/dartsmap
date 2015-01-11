DeviceParam = require "./controller/deviceParam"

spInit = ->
  ###
    DECLARE
  ###
  deviceParam = DeviceParam()

  # get ID
  query = window.location.search.substring 1
  element = query.split "="
  user_id = decodeURIComponent element[ 1 ]
  
  # EVENT LISTENER
  deviceParam.listen "START", ->
    dartsDataStore.push
      user_id: user_id
      message: "start"

  deviceParam.listen "WALK", ->
    dartsDataStore.push
      user_id: user_id
      message: "walk"

  deviceParam.listen "ROTATE", ( heading )->
    $( ".notice" ).text heading
    dartsDataStore.push
      user_id: user_id
      message: "rotate"
      heading: heading

  # INIT
  $( ".wrapper" ).hide()
  $( ".wrapper-sp" ).show()

  deviceParam.exec()

  dartsDataStore.push
    user_id: user_id
    message: "init"

module.exports = spInit
