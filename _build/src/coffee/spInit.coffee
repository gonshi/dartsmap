DeviceParam = require "./controller/deviceParam"

spInit = ->
  ###
    DECLARE
  ###
  deviceParam = DeviceParam()

  # get ID
  query = window.location.search.substring 1
  element = query.split "="
  id = decodeURIComponent element[ 1 ]
  
  # EVENT LISTENER
  deviceParam.listen "START", ->
    dartsDataStore.push
      user_id: id
      message: "start"

  deviceParam.listen "WALK", ->
    dartsDataStore.push
      user_id: id
      message: "walk"

  deviceParam.listen "ROTATE", ( heading )->
    dartsDataStore.push
      user_id: id
      message : "rotate"
      heading: heading

  # INIT
  deviceParam.exec()

  setInterval ->
    dartsDataStore.push
      user_id: id
      message: "init"
  , 1000

module.exports = spInit
