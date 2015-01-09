EventDispatcher = require "../util/eventDispatcher"
instance = null

class PanoramaManager extends EventDispatcher
  constructor: ->
    super()
    @sv = new window.google.maps.StreetViewService()
    panoramaOptions =
      clickToGo: false
      addressControl: false
      linksControl: false
      scrollwheel: false
      panControl: false
      zoomControl: false

    @panorama = new window.google.maps.StreetViewPanorama(
      $( "#panorama" ).get( 0 ), panoramaOptions )

  draw: ( param )->
    _heading  = param.heading || 270 # current heading
    _pitch    = param.pitch || 0 # current pitch
    gap = 0.0001

    @panorama.setVisible false
    if param.latLng
      @sv.getPanoramaByLocation( param.latLng,
          50, # radius to find sv
          _processSVData )
    else if param.panoId
      @sv.getPanoramaById param.panoId, _processSVData

    _processSVData = ( data, status )->
      return if ( status != global.google.maps.StreetViewStatus.OK )
      @panorama.setPano data.location.pano
      @panorama.setPov
        heading: _heading,  # horizon rotation
        pitch: _pitch     # vertical rotation

      # streetView rendering bug fix
      clearInterval interval
      interval = setInterval ->
        @panorama.setPov
          heading: @panorama.getPov().heading, # horizon rotation
          pitch: @panorama.getPov().pitch + gap  # vertical rotation
        gap = gap * -1
      , 1000

      setTimeout ->
        @panorama.setVisible true # panorama fragment bug fix
      , 200

  setRotate: ( target_heading )->
    # convert to -180 ~ 180
    if target_heading > 180
      target_heading = target_heading - 360
    else if target_heading < -180
      target_heading = target_heading + 360

    @panorama.setPov
      heading: target_heading
      pitch: 0

  rotateTo: ( target_heading, target_pitch )->
    current_pov = @panorama.getPov()
    DURATION = 50
    multiVal = 10
    i = 0

    # convert to -180 ~ 180
    if current_pov.heading > 180
      current_pov.heading = current_pov.heading - 360
    else if current_pov.heading < -180
      current_pov.heading = current_pov.heading + 360
    if current_pov.pitch > 180
      current_pov.pitch = current_pov.pitch - 360
    else if current_pov.pitch < -180
      current_pov.pitch = current_pov.pitch + 360

    # convert the margin under 180
    if Math.abs( current_pov.heading - target_heading ) >= 180
      if current_pov.heading < 0
        current_pov.heading += 360
      else
        target_heading += 360

    heading_dir = if ( current_pov.heading > target_heading ) then -1 else 1
    pitch_dir = if ( current_pov.pitch > target_pitch ) then -1 else 1

    timeout = =>
      next_heading  = current_pov.heading + heading_dir * i * multiVal
      next_pitch    = current_pov.pitch + pitch_dir * i * multiVal
      fin_count = 0

      if heading_dir == 1 && next_heading >= target_heading ||
         heading_dir == -1 && next_heading <= target_heading
        next_heading = target_heading
        fin_count += 1
      if pitch_dir == 1 && next_pitch >= target_pitch ||
         pitch_dir == -1 && next_pitch <= target_pitch
        next_pitch = target_pitch
        fin_count += 1

      @panorama.setPov
        heading: next_heading
        pitch: next_pitch

      if fin_count != 2
        i += 1
        setTimeout timeout, DURATION
      else
        @dispatch "ROTATE_FIN", _this

    timeout()

  remove: ->
    @panorama.setVisible false

  get: ( param )->
    switch ( param )
      when "links"
        data = @panorama.getLinks()
        break
      when "pov"
        data = @panorama.getPov()
        break
    return data

getInstance = ->
  if !instance
    instance = new PanoramaManager()
  return instance

module.exports = getInstance
