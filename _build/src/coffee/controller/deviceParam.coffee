EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class DeviceParam extends EventDispatcher
  constructor: ->
    super()
    @ymax = 0
    @zmax = 0
    if isAndroid()
      @start_thr = 20
      @walk_thr = 12
    else
      @start_thr = 45
      @walk_thr = 15

  exec: ->
    motionThrottle = new Throttle 100
    orientThrottle = new Throttle 100
    param = [ "y", "z" ]
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
      for i in [ 0...2 ]
        if abs( e.accelerationIncludingGravity[ param[ i ] ] ) > @start_thr
          @dispatch "START", this
        if abs( e.accelerationIncludingGravity[ param[ i ] ] ) > @walk_thr
          @dispatch "WALK", this

getInstance = ->
  if !instance
    instance = new DeviceParam()
  return instance

module.exports = getInstance
