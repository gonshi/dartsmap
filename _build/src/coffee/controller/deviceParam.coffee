EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class DeviceParam extends EventDispatcher
  constructor: ->
    super()
    @last_acc =
      x: 0
      y: 0
      z: 0

    if isAndroid()
      @walk_thr = 9
      @isAndroid = true
    else
      @start_thr = 45
      @walk_thr = 12

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
      param = [ "x", "y", "z" ]
      for i in [ 0...param.length ]
        low_passed_val = @last_acc[ param[ i ] ] * 0.9 +
        abs( e.accelerationIncludingGravity[ param[ i ] ] ) * 0.1

        if low_passed_val > @start_thr
          @dispatch "START", this
        if low_passed_val > @walk_thr
          @dispatch "WALK", this
          break
        @last_acc[ param[ i ] ] = low_passed_val
      $( ".notice" ).html "x:#{ @last_acc.x }<br>y:#{ @last_acc.y }<br>" +
                          "z:#{ @last_acc.z }"

getInstance = ->
  if !instance
    instance = new DeviceParam()
  return instance

module.exports = getInstance
