instance = null

class SocialCallback
  # PRIVATE
  watch: ->
    # native twitter btn
    window.twttr.ready ( twttr )->
      twttr.events.bind "tweet", ->
        _callback "tw"

    # native facebook btn
    window.fbAsyncInit = ->
      window.FB.init
        appId      : "", # TODO
        xfbml      : true,
        version    : "v2.2"
        window.FB.Event.subscribe "edge.create",
          ( response )->
            if response
              _callback "fb-like"

    # twitter share
    $( document ).on "click", ".tweet", ( e )->
      e.preventDefault()

      if window.screenLeft?
        dualScreenLeft = window.screenLeft
        dualScreenTop = window.screenTop
      else
        dualScreenLeft = screen.left
        dualScreenTop = screen.top

      if window.innerWidth?
        windowWidth = window.innerWidth
        windowHeight = window.innerHeight
      else if document.documentElement?.clientWidth?
        windowWidth = document.documentElement.clientWidth
        windowWidth = document.documentElement.clientHeight
      else
        windowWidth = screen.width
        windowWidth = screen.height

      popupWidth = 650
      popupHeight = 450

      left = ( ( windowWidth / 2 ) - ( popupWidth / 2 ) ) + dualScreenLeft
      top = ( ( windowHeight / 2 ) - ( popupHeight / 2 ) ) + dualScreenTop

      url = $( e.currentTarget ).find( "a" ).attr "href"

      window.open url,
                  "Twitterでリンクを共有する",
                  "width=#{ popupWidth }, height=#{ popupHeight }, " +
                  "top=#{ top }, left=#{ left }"

    _callback = ( type )->
      console.log type

module.exports = SocialCallback

getInstance = ->
  if !instance
    instance = new SocialCallback()
  return instance

module.exports = getInstance
###
  # call share
  window.FB.ui
    method: "share"
    href: "" # TODO
###
