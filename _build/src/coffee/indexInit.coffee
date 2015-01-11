indexInit = ->
  ###
    DECLARE
  ###
  user_id = Math.floor( Math.random() * 1000 )
  $arrow = $( ".arrow" )
  is_started = false

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
      , 3000

      dartsDataStore.on "push", ( e )->
        if e.value.message == "start"
          if is_started || parseInt( e.value.user_id ) != parseInt( user_id )
            return

          is_started = true
          target_top = $( ".map .goal" ).offset().top
          target_left = $( ".map .goal" ).offset().left - 200
          # 200 = arrow width


          # THROW ARROW
          $( ".chara" ).addClass "throw"
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
              window.location.href = "panorama.html?lat=21.273006&" +
                                     "lng=-157.8236413&user_id=#{ user_id }"
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
