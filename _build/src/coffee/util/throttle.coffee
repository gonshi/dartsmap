class Throttle
  if global?.performance?.now?
    getNow = ->
      global.performance.now()
  else
    getNow = ->
      Date.now()

  constructor: ( minInterval )->
    @is_first = true
    @interval = minInterval
    @prevTime = 0
    @timer = null
 
  exec: ( callback )->
    now = getNow()
    delta = now - @prevTime

    clearTimeout( @timer )
    if delta >= @interval
      @prevTime = now
      callback()
    else
      @timer = setTimeout callback, @interval

  first: ( callback )->
    if @is_first
      @is_first = false
      callback()

  last: ( callback )->
    clearTimeout @timer
    @timer = setTimeout =>
      callback()
      @is_first = true
    , @interval

module.exports = Throttle
