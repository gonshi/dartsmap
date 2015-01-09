PI = Math.PI
sin = Math.sin

easing = ->
  Math.easeOutQuad = ( current_t, from, to, duration )->
    return if current_t > duration
    to * sin( current_t / duration * ( PI / 2 ) ) + from

module.exports = easing
