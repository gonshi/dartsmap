panoramaData = require "./model/panoramaData"

docCookies =
  getItem: (sKey) ->
    if !sKey or !@hasItem(sKey)
      return null
    unescape document.cookie.replace(
      new RegExp('(?:^|.*;\\s*)' + escape(sKey).replace(/[\-\.\+\*]/g, '\\$&') +
      '\\s*\\=\\s*((?:[^;](?!;))*[^;]?).*'), '$1'
    )
  setItem: (sKey, sValue, vEnd, sPath, sDomain, bSecure) ->
    if !sKey or /^(?:expires|max\-age|path|domain|secure)$/i.test(sKey)
      return
    sExpires = ''
    if vEnd
      switch vEnd.constructor
        when Number
          if vEnd == Infinity
            sExpires = '; expires=Tue, 19 Jan 2038 03:14:07 GMT'
          else
            sExpires = '; max-age=' + vEnd
        when String
          sExpires = '; expires=' + vEnd
        when Date
          sExpires = '; expires=' + vEnd.toGMTString()
    document.cookie = escape(sKey) + '=' + escape(sValue) + sExpires +
                      (if sDomain then '; domain=' + sDomain else '') +
                      (if sPath then '; path=' + sPath else '') +
                      (if bSecure then '; secure' else '')
    return
  removeItem: (sKey, sPath) ->
    if !sKey or !@hasItem(sKey)
      return
    document.cookie = escape(sKey) +
                      '=; expires=Thu, 01 Jan 1970 00:00:00 GMT' +
                      (if sPath then '; path=' + sPath else '')
    return
  hasItem: (sKey) ->
    new RegExp(
      '(?:^|;\\s*)' +
      escape(sKey).replace(/[\-\.\+\*]/g, '\\$&') +
      '\\s*\\='
    ).test document.cookie
  keys: ->
    aKeys = document.cookie.replace(
      /((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, ''
    ).split(/\s*(?:\=[^;]*)?;\s*/)
    nIdx = 0
    while nIdx < aKeys.length
      aKeys[nIdx] = unescape(aKeys[nIdx])
      nIdx++
    aKeys

indexInit = ->
  _target_id = null
  _target_history_list = []

  # PRIVATE
  _check_target_id = ->
    for i in [0..._target_history_list.length]
      if parseInt(_target_id) == parseInt(_target_history_list[i])
        _target_id = (_target_id + 1) % panoramaData.length
        _check_target_id()
        break

  ###
    DECLARE
  ###
  user_id = Math.floor( Math.random() * 1000 )
  $arrow = $( ".arrow" )
  is_started = false

  # 一度出た国は続けて出ないようにする
  _target_history = docCookies.getItem("target_history")
  if _target_history
    _target_history = _target_history.split ", "
  else
    _target_history = []

  for i in [0..._target_history.length]
    if _target_history[i] != "null"
      _target_history_list.push _target_history[i]

  if _target_history_list.length >= panoramaData.length
    docCookies.removeItem "target_history"
    location.reload()
    return

  # bubble sort
  for i in [0..._target_history_list.length]
    for j in [i + 1..._target_history_list.length]
      if _target_history_list[j] < _target_history_list[i]
        _tmp = _target_history_list[i]
        _target_history_list[i] = _target_history_list[j]
        _target_history_list[j] = _tmp

  _target_id = Math.floor( Math.random() * panoramaData.length )

  _check_target_id()

  target = panoramaData[ _target_id ]
  param = {}

  docCookies.setItem(
    "target_history", "#{docCookies.getItem("target_history")}, #{_target_id}"
  )

  ###
  if window.DEBUG.state
    $( ".qrCode_container" ).hide()
    $( ".map .target" ).css opacity: 1
    target = panoramaData[ 5 ]
  ###

  # preload
  preLoadImg = []
  preLoadImg[ 0 ] = new Image()
  preLoadImg[ 0 ].src = "img/arrow.png"

  ###
    PRIVATE
  ###

  _session_start = ->
    $( ".qrCode_container" ).animate
      opacity: 0
    , 300, -> $( ".qrCode_container" ).hide()

    setTimeout ->
      $( ".tutorial" ).addClass "show"
      setTimeout (-> $( ".tutorial" ).addClass "hide" ), 10000
    , 1500

    dartsDataStore.on "send", ( e )->
      if e.value.message == "start"
        if is_started || parseInt( e.value.user_id ) != parseInt( user_id )
          return

        is_started = true

        $( ".map .target" ).css
          top: target.top
          left: target.left

        target_offsetTop = $( ".map .target" ).offset().top - 20
        target_offsetLeft = $( ".map .target" ).offset().left - 198

        # THROW ARROW
        $( ".chara" ).addClass "throw"
        $( ".map .name" ).text( target.name ).css
          top: target.top - 60
          left: target.left

        $arrow.show().animate
          width: 200
          top: target_offsetTop
          left: target_offsetLeft
        , 800, "easeInQuad", ->
          $arrow.addClass "vibration"
          # ZOOM MAP
          setTimeout ->
            $( ".wrapper" ).css transform: "scale(2.0)"
          , 1000
          setTimeout ->
            $( ".map .name" ).show().addClass( "show" )
          , 2000
          setTimeout ->
            $( ".wrapper" ).animate
              opacity: 0
            , 1500, ->
              window.location.href = "panorama.html?lat=#{ target.lat }&" +
                                      "lng=#{ target.lng }&" +
                                      "user_id=#{ user_id }"
          , 3000


  # milkcocoa LISTENER
  dartsDataStore.on "send", ( e )->
    if e.value.message == "init" &&
       parseInt( e.value.user_id ) == parseInt( user_id )

      _session_start()

  # INIT
  $arrow.css
    top: $( ".chara .start" ).offset().top
    left: $( ".chara .start" ).offset().left

  $qrCodeImg = $( "<img>" ).attr
    src: "http://chart.apis.google.com/chart?chs=480x480&cht=qr&chl=" +
          "#{ window.location.href }?user_id=#{ user_id }",
    alt: "QRコード"
  $qrCodeImg.appendTo ".qrCode"

  query = window.location.search.substring 1 # remove "?"
  _param = query.split "&"
  if _param.length > 0
    for i in [ 0..._param.length ]
      element = _param[ i ].split "="
      key = decodeURIComponent element[ 0 ]
      value = decodeURIComponent element[ 1 ]
      param[ key ] = value

  if param.user_id? # パノラマページからもどってきたとき
    user_id = param.user_id
    _session_start()

  if window.DEBUG.state
    window.test = ->
      $( ".map .target" ).css
        top: target.top
        left: target.left

      target_offsetTop = $( ".map .target" ).offset().top - 20
      target_offsetLeft = $( ".map .target" ).offset().left - 198

      # THROW ARROW
      $( ".chara" ).addClass "throw"
      $( ".map .name" ).text( target.name ).css
        top: target.top - 70
        left: target.left

      $arrow.show().animate
        width: 200
        top: target_offsetTop
        left: target_offsetLeft
      , 800, "easeInQuad", ->
        $arrow.addClass "vibration"
        # ZOOM MAP
        setTimeout ->
          $( ".wrapper" ).css transform: "scale(2.0)"
        , 1000
        setTimeout ->
          $( ".map .name" ).show().addClass( "show" )
        , 2000
        setTimeout ->
          $( ".wrapper" ).animate
            opacity: 0
          , 1500, ->
            window.location.href = "panorama.html?lat=#{ target.lat }&" +
                                    "lng=#{ target.lng }&user_id=#{ user_id }"
        , 3000

module.exports = indexInit
