EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class DeviceParam extends EventDispatcher
  constructor: ->
    super()
    if isAndroid()
      @start_thr = 25
      @walk_thr = 7
      @isAndroid = true
    else
      @start_thr = 45
      @walk_thr = 12
      @isAndroid = false

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
      param = [ "x", "y", "z "]
      if @isAndroid
        $( ".notice" ).text "android"
        if abs( e.accelerationIncludingGravity.y ) > @start_thr
          @dispatch "START", this
        if abs( e.accelerationIncludingGravity.y ) > @walk_thr
          @dispatch "WALK", this
      else
        for i in [ 0...param.length ]
          if abs( e.accelerationIncludingGravity[ param[ i ] ] ) > @start_thr
            @dispatch "START", this
          if abs( e.accelerationIncludingGravity[ param[ i ] ] ) > @walk_thr
            @dispatch "WALK", this
            break

getInstance = ->
  if !instance
    instance = new DeviceParam()
  return instance

module.exports = getInstance
