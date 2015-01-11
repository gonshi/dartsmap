panoramaData = require "./model/panoramaData"

indexInit = ->
  ###
    DECLARE
  ###
  user_id = Math.floor( Math.random() * 1000 )
  $arrow = $( ".arrow" )
  is_started = false
  target = panoramaData[ Math.floor( Math.random() * panoramaData.length ) ]

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

          target_top = $( ".map .target" ).offset().top
          target_left = $( ".map .target" ).offset().left - 200

          # THROW ARROW
          $( ".chara" ).addClass "throw"
          $( ".map .name" ).text target.name
          $arrow.show().animate
            width: 200
            top: target_top
            left: target_left
          , 800, "easeInQuad", ->
            $arrow.addClass "vibration"
            # ZOOM MAP
            setTimeout ->
              $( ".wrapper" ).css transform: "scale( 2.0 )"
            , 1000
            setTimeout ->
              $( ".map .name" ).show().addClass( "show" )
            , 2000
            setTimeout ->
              window.location.href = "panorama.html?lat=#{ target.lat }&" +
                                     "lng=#{ target.lng }&user_id=#{ user_id }"
            , 5000

  # INIT
  $arrow.css
    top: $( ".chara .start" ).offset().top
    left: $( ".chara .start" ).offset().left

  $qrCodeImg = $( "<img>" ).attr
    src: "http://chart.apis.google.com/chart?chs=480x480&cht=qr&chl=" +
          "#{ window.location.href }?user_id=#{ user_id }",
    alt: "QRコード"
  $qrCodeImg.appendTo ".qrCode"

module.exports = indexInit
