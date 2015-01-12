EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class DeviceParam extends EventDispatcher
  constructor: ->
    super()
    @last_heading = 0
    if isAndroid()
      @start_thr = 20
      @walk_thr = 6
    else
      @start_thr = 40
      @walk_thr = 13

  exec: ->
    motionThrottle = new Throttle 100
    orientThrottle = new Throttle 100
    param = [ "x", "y", "z" ]
    abs = Math.abs

    # LISTENER
    window.addEventListener "devicemotion", ( e )->
      motionThrottle.exec ->
        _checkAccel e

    window.addEventListener "deviceorientation", ( e )=>
      $( ".notice" ).text e.alpha
      ###
      orientThrottle.exec =>
        heading = e.webkitCompassHeading
        if heading < 0
          heading += 360
        heading += window.orientation

        if abs( heading - @last_heading ) > 20
          @last_heading = heading
          @dispatch "ROTATE", this, -heading
      ###

    ###
      PRIVATE
    ###
    _checkAccel = ( e )=>
      for i in [ 0...3 ]
        if abs( e.accelerationIncludingGravity[ param[ i ] ] ) > @start_thr
          @dispatch "START", this
        if abs( e.accelerationIncludingGravity[ param[ i ] ] ) > @walk_thr
          @dispatch "WALK", this

getInstance = ->
  if !instance
    instance = new DeviceParam()
  return instance

module.exports = getInstance
