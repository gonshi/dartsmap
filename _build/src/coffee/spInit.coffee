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
      id: id
      message: "start"

  deviceParam.listen "WALK", ->
    dartsDataStore.push
      id: id
      message: "walk"

  deviceParam.listen "ROTATE", ( heading )->
    dartsDataStore.push
      id: id
      message : "rotate"
      heading: heading

  # INIT
  deviceParam.exec()

  dartsDataStore.push
    id: id
    message: "init"

module.exports = spInit
