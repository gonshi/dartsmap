EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class DeviceParam extends EventDispatcher
  constructor: ->
    super()

  exec: ->
    throttle = new Throttle 100
    param = [ "x", "y", "z" ]
    abs = Math.abs

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

    ###
      PRIVATE
    ###
    _checkAccel = ( e )=>
      for i in [ 0...3 ]
        if abs( e.acceleration[ param[ i ] ] ) > 50
          @dispatch "START". this
        else if abs( e.acceleration[ param[ i ] ] ) > 15
          @dispatch "WALK", this

getInstance = ->
  if !instance
    instance = new DeviceParam()
  return instance

module.exports = getInstance
