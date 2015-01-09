Ticker = require "../util/ticker"
easing = require "../util/easing"
easing()

class Query
  constructor: ( selector )->
    re = /^<(.*?)>/
    if _selector = re.exec( selector )
      @elms = [ document.createElement( _selector[ 1 ] ) ]
    else
      @elms = document.querySelectorAll( selector )

  hasClass: ( className, i = 0 )->
    @elms[ i ].className.split( /\s/ ).indexOf( className ) != -1

  addClass: ( className )->
    for i in [ 0...@elms.length ]
      if @hasClass( className, i )
        null
      else
        if @elms[ i ].className == ""
          @elms[ i ].className += className
        else
          @elms[ i ].className += " " + className
    @

  removeClass: ( className )->
    for i in [ 0...@elms.length ]
      @elms[ i ].className = @elms[ i ].className.split( /\s/ ).
                             filter( ( j )-> j != className ).
                             join( " " )
    @

  css: ( props )->
    for i in [ 0...@elms.length ]
      for key,value of props
        @elms[ i ].style[ key ] = value
    @

  animate: ->
    ticker = new Ticker()
    from = []
    to = []
    elmLength = @elms.length
    re = /^[+\-]?(\d+)(\D+)/i

    # defaults
    duration = 500
    easing = "easeOutQuad"

    for i in [ 0...arguments.length ]
      arg = arguments[ i ]
      switch( typeof arg )
        when "object" then props = arg
        when "number" then duration = arg
        when "string" then easing = arg
        when "function" then callback = arg

    for i in [ 0...elmLength ]
      for key, value of props
        if key == "scrollTop"
          from[ i ] = @elms[ i ].scrollTop
        else
          unit = @elms[ i ].style[ key ].match( re )[ 2 ]
          from[ i ] = parseInt( @elms[ i ].style[ key ] )
        to[ i ] = value

    ticker.listen ( e )->
      if e.runTime >= duration
        ticker.stop()
        for i in [ 0...elmLength ]
          _setVal( i, to[ i ] )
        callback() if callback?
      else
        for i in [ 0...elmLength ]
          val = Math[ easing ]( e.runTime, from[ i ],
                                to[ i ] - from[ i ], duration )
          _setVal( i, val )

    _setVal = ( i, val )=>
      if key == "scrollTop"
        @elms[ i ].scrollTop = val
      else
        @elms[ i ].style[ key ] = "#{val}#{unit}"

    @

  on: ( event, listener )->
    for elm in @elms
      elm.addEventListener( event, listener, false )
    @

  get: ( num )->
    @elms[ num ]

  eq: ( num )->
    new SingleQuery( @elms, num )

  size: ->
    @elms.length

class SingleQuery extends Query
  constructor: ( elms, num )->
    @elms = []
    @elms[ 0 ] = elms[ num ]

$ = ( selector )->
  new Query( selector )

module.exports = $
