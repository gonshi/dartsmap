EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class DeviceParam extends EventDispatcher
  constructor: ->
    super()
    @last_heading = 0
    @count = 0

  exec: ->
    throttle = new Throttle 100
    param = [ "x", "y", "z" ]
    abs = Math.abs
    $debug = $( ".debug" )

    # LISTENER
    window.addEventListener "devicemotion", ( e )->
      throttle.exec ->
        _checkAccel e

    window.addEventListener "deviceorientation", ( e )=>
      throttle.exec =>
        @count += 1
        heading = e.webkitCompassHeading
        if heading < 0
          heading += 360
        heading += window.orientation
        $debug.text "#{ heading } : #{ @count }"

        if abs( heading - @last_heading ) > 20
          @last_heading = heading
          @dispatch "ROTATE", this, -heading

    ###
      PRIVATE
    ###
    _checkAccel = ( e )=>
      for i in [ 0...3 ]
        if abs( e.acceleration[ param[ i ] ] ) > 50
          @dispatch "START", this
        if abs( e.acceleration[ param[ i ] ] ) > 25
          @dispatch "WALK", this

getInstance = ->
  if !instance
    instance = new DeviceParam()
  return instance

module.exports = getInstance
