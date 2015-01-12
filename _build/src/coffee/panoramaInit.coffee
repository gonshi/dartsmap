PanoramaManager = require "./view/panoramaManager"

panoramaInit = ->
  ###
    DECLARE
  ###
  panoramaManager = PanoramaManager()
  last_heading = 0
  is_walking = false
  nearestLink = {}
  param = {}

  # milkcocoa LISTENER
  ## forward
  dartsDataStore.on "push", ( e )->
    return if e.value.user_id != param.user_id
    if e.value.message == "walk"
      return if is_walking
      is_walking = true

      _moveForward()
      panoramaManager.draw
        panoId  : nearestLink.pano
        heading : nearestLink.heading
        pitch   : nearestLink.pitch
    else if e.value.message == "rotate"
      return if is_walking
      panoramaManager.setRotate(
        panoramaManager.get( "pov" ).heading -
        ( e.value.heading - last_heading ) )
      last_heading = e.value.heading

  ###
    PRIVATE
  ###
  _moveForward = ->
    myHeading = panoramaManager.get( "pov" ).heading
    myHeading = myHeading + 360 if myHeading < 0

    nextLinks = panoramaManager.get "links"
    nearestDiff = 360 # default is max degree.
    for i in [ 0...nextLinks.length ]
      if Math.abs( myHeading - nextLinks[ i ].heading ) < nearestDiff
        nearestDiff = Math.abs myHeading - nextLinks[ i ].heading
        nearestLink = nextLinks[ i ]

    # convert to -180 ~ 180
    if nearestLink.heading > 180
      nearestLink.heading = nearestLink.heading - 360
    else if nearestLink.heading < -180
      nearestLink.heading = nearestLink.heading + 360

    panoramaManager.setRotate nearestLink.heading, 0
    _walkAnimation()

  # WALK ANIMATION
  _walkAnimation = ->
    walk_width = 195
    count = 0
    max = 4
    timeout = ->
      if count % 2 == 0
        $( ".walk" ).addClass "alt"
      else
        $( ".walk" ).removeClass "alt"
      count += 1
      if count != max
        setTimeout timeout, 500
      else
        is_walking = false
    timeout()

  ###
    INIT
  ###
  # read panorama location
  query = window.location.search.substring 1 # remove "?"
  _param = query.split "&"
  if _param.length > 1
    for i in [ 0..._param.length ]
      element = _param[ i ].split "="
      key = decodeURIComponent element[ 0 ]
      value = decodeURIComponent element[ 1 ]
      param[ key ] = value
  else
    window.location.href = "./"

  panoramaManager.draw
    latLng: new window.google.maps.LatLng param.lat, param.lng
    heading: 270
    pitch: 0

  setTimeout ->
    $( ".tutorial" ).addClass "show"

    setTimeout ->
      $( ".tutorial" ).addClass "hide"
    , 5000
  , 3000

module.exports = panoramaInit
