instance = null

class Ticker
  if global?.performance?.now?
    getNow = ->
      global.performance.now()
  else
    getNow = ->
      Date.now()

  constructor: ->
    @interval = @fps = 0
    @now = @startTime = @prevTime =
    @prevSecondTime = getNow()

    @listeners = []

    @timeout = null

    @data = {}
    @fps_counter = 0

    @setFps 30
    @timer()

  setFps: ( _fps )->
    @fps = _fps
    @interval = 1000 / _fps

  listen: ( callback )->
    @listeners.push callback

  stop: ->
    window.clearTimeout( @timeout )

  timer: ->
    @now = getNow()
    @data.runTime = @now - @startTime
    @data.delta = @now - @prevTime
    @prevTime = @now

    @fps_counter += 1
    if @fps_counter == @fps
      @data.measuredFps = @fps /
                          ( ( @now - @prevSecondTime ) / 1000 )
      @prevSecondTime = @now
      @fps_counter = 0

    @timeout = setTimeout =>
      @timer()
    , @interval

    for listener in @listeners
      listener @data

getInstance = ->
  if !instance
    instance = new Ticker()
  return instance

module.exports = getInstance
