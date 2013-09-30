###
  input[type="password"] / input[type="text"]
  © 2013 by Anton Romanov
  anton@rmnv.ru
###

'use strict'

PASSY_CLASS       = 'passy'
TRIGGER_CLASS     = PASSY_CLASS  + '__trigger'
INPUT_CLASS       = PASSY_CLASS  + '__input'
ICON_CLASS        = PASSY_CLASS  + '__icon'
ICON_CLOSED_CLASS = ICON_CLASS   + '_closed'
ICON_OPENED_CLASS = ICON_CLASS   + '_opened'
TYPES             = ['text', 'password']



self =

  _setSelect: (input, start, end) ->
    end = start unless end
    input.each ->
      if @setSelectionRange
        @focus()
        @setSelectionRange(start, end)
      else if @createTextRange
        range = @createTextRange()
        range.collapse(true)
        range.moveEnd("character", end)
        range.moveStart("character", start)
        range.select()
        input.focus()

  getSelect: (input) ->
    CaretPos = 0 # IE Support
    if document.selection
      input.focus()
      Sel = document.selection.createRange()
      Sel.moveStart "character", -input.value.length
      CaretPos = Sel.text.length

      # Firefox support
    if input.selectionStart or input.selectionStart is 0
      CaretPos = input.selectionStart

    return CaretPos

  # input[type="password"] / input[type="text"]
  _setInputType: (input, type, where) ->
    where.prepend(input.detach().attr('type', type))
    input

  # Toggle «Show symbols» / «Hide symbols»
  _setTitle: (trigger, type, o) ->
    title = if type is TYPES[0] then o.titleofhide else o.titleofshow
    trigger.attr('title', title)

  # Create span.passy__trigger
  _createTrigger: (insertAfter) ->
    trigger = $('<span class="'+TRIGGER_CLASS+'"></span>')
    trigger.insertAfter(insertAfter)

  # Create i.passy__icon
  _createIcon: (prepend) ->
    icon = $('<i class="'+ICON_CLASS+'">')
    prepend.prepend(icon)
    return icon

  # Toggle passy__icon_closed / passy__icon_opened
  _setIconClass: (icon, type) ->
    oldClass = ICON_OPENED_CLASS
    newClass = ICON_CLOSED_CLASS
    if type is TYPES[0]
      oldClass = [newClass, newClass = oldClass][0] # var reverse
    icon.removeClass(oldClass).addClass(newClass)
    return icon

  # pass 'text', get 'password'
  _getNextType: (nowType) ->
    oldType = TYPES[0]
    newType = TYPES[1]
    if nowType is newType
      oldType = [newType, newType = oldType][0]
    return newType


  # On eye click
  _setTriggerBinds: (trigger, data) ->
    o = data.options; info = data.info; node = data.node
    trigger.on 'click.passy', (event) ->
      self.type('toggle', node.input)
      event.preventDefault()
    # for isHasFocus = true
    trigger.on 'mousedown.passy', ->
      info.isTriggerClick = true
      true
    trigger.on 'mouseup.passy', ->
      info.isTriggerClick = false
      true
    trigger


  # On .passy__input focus
  _setFocusBinds: (input, info) ->
    input.on 'focusin.passy', ->
      info.isHasFocus = true
      true
    input.on 'focusout.passy', ->
      unless info.isTriggerClick
        info.isHasFocus = false
        true
    input






  _setType: (type, data) ->
    node = data.node; info = data.info; o = data.options

    node.trigger = self._setTitle(node.trigger, type, o)
    node.icon = self._setIconClass(node.icon, type)
    node.input = self._setInputType(node.input, type, node.wrapper)

    self._setFocusBinds(node.input, info)

    info.nowType = type
    info.nextType = self._getNextType(info.nowType)

    if info.isHasFocus then node.input.focus()

    return data


  type: (type, input = @) ->
    input.each ->
      data = $(this).parent().data('passy')
      node = data.node; o = data.options; info = data.info

      # input.passyriot('type')
      unless type
        return info.nowType

      # input.passyriot('type', 'toggle') or click
      else if type is 'toggle'
        return self._setType(info.nextType, data)

      # input.passyriot('type', '...')
      else if type is info.nextType or info.isFirst
        info.isFirst = false
        return self._setType(type, data)




  init: (userOptions) ->
    @each ->
      unless data
        input = $(this)
        startTag = input.prop('tagName').toLowerCase()
        startType = input.prop('type')
        if startTag is 'input' and startType is 'password'
          defaultOptions =
            defaulttype: 'password' # text/password
            titleofshow: 'Show simbols'
            titleofhide: 'Hide simbols'
            hashonhover: 'passyriot'
          options = $.extend {},
            defaultOptions, userOptions, input.data()
          data = self._constructor(input, options)
          node = data.node; o = data.options
          self.type(o.defaulttype, node.input)
          return $(this)
        else
          $.error input + 'must be input[type="password"]'

  destroy: () ->
    @each ->
      data = $(this).parent().data('passy')
      node = data.node; o = data.options; info = data.info
      self._setType('password', data)
      node.trigger.remove()
      node.input.off('.passy').unwrap(node).removeClass(INPUT_CLASS)
      return $(this)

  _constructor: (input, options) ->
    wrapper = input.wrap('<span class="'+PASSY_CLASS+'">').parent()
    wrapper.data('passy', {
      options: options
      node: {}
      info: {}
    })
    data = wrapper.data('passy')
    node = data.node; o = data.options; info = data.info

    info.nowType  = o.defaulttype
    info.isFirst  = true
    node.wrapper  = wrapper
    node.input    = input.addClass(INPUT_CLASS)
    node.trigger  = self._createTrigger(node.input)
    node.icon     = self._createIcon(node.trigger)
    self._setTriggerBinds(data.node.trigger, data)
    return data

# auto init
$ ->
  $('.passyriot:not([data-auto="false"])').passyriot()

$.fn.passyriot = (method) ->
  if self[method]
    self[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is 'object' or not method
    self.init.apply this, arguments
  else
    $.error method + ' not found'


