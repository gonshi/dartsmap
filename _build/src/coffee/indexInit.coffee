panoramaData = require "./model/panoramaData"

indexInit = ->
  ###
    DECLARE
  ###
  user_id = Math.floor( Math.random() * 1000 )
  $arrow = $( ".arrow" )
  is_started = false
  target = panoramaData[ Math.floor( Math.random() * panoramaData.length ) ]
  if window.DEBUG
    $( ".qrCode_container" ).hide()
    $( ".map .target" ).show()
    target = panoramaData[ 6 ]

  # preload
  preLoadImg = []
  preLoadImg[ 0 ] = new Image()
  preLoadImg[ 0 ].src = "img/arrow.png"

  # milkcocoa LISTENER
  dartsDataStore.on "push", ( e )->
    if e.value.message == "init" && parseInt(
      e.value.user_id ) == parseInt( user_id )
      $( ".qrCode_container" ).animate
        opacity: 0
      , 300, -> $( ".qrCode_container" ).hide()

      setTimeout ->
        $( ".tutorial" ).addClass "show"
        setTimeout (-> $( ".tutorial" ).addClass "hide" ), 5000
      , 1500

      dartsDataStore.on "push", ( e )->
        if e.value.message == "start"
          if is_started || parseInt( e.value.user_id ) != parseInt( user_id )
            return

          is_started = true

          $( ".map .target" ).css
            top: target.top
            left: target.left

          target_offsetTop = $( ".map .target" ).offset().top
          target_offsetLeft = $( ".map .target" ).offset().left - 200

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

  # INIT
  $arrow.css
    top: $( ".chara .start" ).offset().top
    left: $( ".chara .start" ).offset().left

  $qrCodeImg = $( "<img>" ).attr
    src: "http://chart.apis.google.com/chart?chs=480x480&cht=qr&chl=" +
          "#{ window.location.href }?user_id=#{ user_id }",
    alt: "QRコード"
  $qrCodeImg.appendTo ".qrCode"

  if window.DEBUG
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
