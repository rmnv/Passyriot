window.log = ->
  log.history = log.history || []
  log.history.push arguments
  if this.console
    console.log Array.prototype.slice.call arguments

# after 1000, -> addSec()
window.after = (ms, fn) ->
  setTimeout(fn, ms)

jQuery ($) ->

#  $('.passyriot').eq(1).passyriot()

  # $('.passyriot').passyriot('type')
  # $('.passyriot').passyriot('type', 'toggle')
  # $('.passyriot').passyriot('type', 'password')
  # $('.passyriot').passyriot('type', 'text')



