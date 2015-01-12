EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class DeviceParam extends EventDispatcher
  constructor: ->
    super()
    if isAndroid()
      @start_thr = 40
      @walk_thr = 40
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
      orientThrottle.exec =>
        @dispatch "ROTATE", this, -e.alpha

    ###
      PRIVATE
    ###
    _checkAccel = ( e )=>
      $( ".notice" ).text abs( e.accelerationIncludingGravity.x  )
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
