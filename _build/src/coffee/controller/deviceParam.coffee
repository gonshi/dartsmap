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

    @max =
      x: 0
      y: 0
      z: 0

    @start_thr = 12
    @walk_thr = 10

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

        @last_acc[ param[ i ] ] = low_passed_val
        if @last_acc[ param[ i ] ] > @max[ param[ i ] ]
          @max[ param[ i ] ] = @last_acc[ param[ i ] ]

        if low_passed_val > @start_thr
          @dispatch "START", this
        if low_passed_val > @walk_thr
          @dispatch "WALK", this
          break

      $( ".notice" ).html "maxX: #{ @max.x.toFixed( 2 ) }<br>" +
                          "maxY: #{ @max.y.toFixed( 2 ) }<br>" +
                          "maxZ: #{ @max.z.toFixed( 2 ) }<br>" +
                          "x:#{ @last_acc.x.toFixed( 2 ) }<br>" +
                          "y:#{ @last_acc.y.toFixed( 2 ) }<br>" +
                          "z:#{ @last_acc.z.toFixed( 2 ) }"

getInstance = ->
  if !instance
    instance = new DeviceParam()
  return instance

module.exports = getInstance
