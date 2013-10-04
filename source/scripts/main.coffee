window.log = ->
  log.history = log.history || []
  log.history.push arguments
  if this.console
    console.log Array.prototype.slice.call arguments

# after 1000, -> addSec()
window.after = (ms, fn) ->
  setTimeout(fn, ms)

jQuery ($) ->
  pussy = $('.pussyriot')
  pussyOpenedClass = 'pussyriot_opened'
  hint = $('.preview__hint')
  hintHideClass = 'preview__hint_hide'
  input = $('input[type="password"]')
  input.passyriot
    defaulttype: 'password'
    titleofshow: 'Показать символы'
    titleofhide: 'Скрыть символы'
    iconclass: 'svg-eye'
    iconopenedclass: 'svg-eye_opened'
    iconclosedclass: 'svg-eye_closed'
    onTypeChange: (data) ->
      if data.info.nowType is 'text'
        pussy.addClass(pussyOpenedClass)
        hint.addClass(hintHideClass)
      else
        pussy.removeClass(pussyOpenedClass)
        hint.removeClass(hintHideClass)

#  $('.passyriot').eq(1).passyriot()

  # $('.passyriot').passyriot()
  # $('.passyriot').passyriot('type', 'toggle')
  # $('.passyriot').passyriot('type', 'password')
  # $('.passyriot').passyriot('type', 'text')



