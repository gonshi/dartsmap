prefix = {}

prefix.transitionend = "webkitTransitionEnd otransitionend " +
                       "oTransitionEnd msTransitionEnd "     +
                       "transitionend"
prefix.animationend = "webkitAnimationEnd oanimationend " +
                      "oAnimationEnd msAnimationEnd "     +
                      "animationend"
prefix.iterationend = "animationiteration webkitAnimationIteration " +
                      "oanimationiteration MSAnimationIteration"
module.exports = prefix
