EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class DeviceParam extends EventDispatcher
  constructor: ->
    super()
    @ymax = 0
    if isAndroid()
      @start_thr = 30
      @walk_thr = 12
    else
      @start_thr = 45
      @walk_thr = 15

  exec: ->
    motionThrottle = new Throttle 100
    orientThrottle = new Throttle 100
    abs = Math.abs

    # LISTENER
    window.addEventListener "devicemotion", ( e )->
      motionThrottle.exec ->
        _checkAccel e

    window.addEventListener "deviceorientation", ( e )=>
      orientThrottle.exec =>
        @dispatch "ROTATE", this, e.alpha

    ###
      PRIVATE
    ###
    _checkAccel = ( e )=>
      _abs = abs( e.accelerationIncludingGravity.y )
      @ymax = _abs if _abs > @ymax
      $( ".notice" ).text @ymax
      if abs( e.accelerationIncludingGravity.y ) > @start_thr
        @dispatch "START", this
      if abs( e.accelerationIncludingGravity.y ) > @walk_thr
        @dispatch "WALK", this

getInstance = ->
  if !instance
    instance = new DeviceParam()
  return instance

module.exports = getInstance
