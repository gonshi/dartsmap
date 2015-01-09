EventDispatcher = require "../util/eventDispatcher"
instace = null
  
class DeviceParam extends EventDispatcher
  constructor: ->
    super()

  exec: ->
    throttle = new ns.Throttle 100
    abs = Math.abs
    param = [ "x", "y", "z" ]

    # LISTENER
    window.addEventListener "devicemotion", ( e )->
      throttle.exec ->
        _checkAccel e

    window.addEventListener "deviceorientation", ( e )=>
      throttle.exec =>
        heading = e.webkitCompassHeading
        if heading < 0
          heading += 360
        heading += window.orientation
        @dispatch "ROTATE", this, -heading

_checkAccel = ( e )->
  for i in [ 0...3 ]
    if abs( e.acceleration[ param[ i ] ] ) > 50
      @dispatch "START"
    else if abs( e.acceleration[ param[ i ] ] ) > 15
      @dispatch( "WALK" )

getInstance = ->
  if !instance
    instance = new DeviceParam()
  return instance

module.exports = getInstance
