###
  input[type="password"] / input[type="text"]
  © 2013 by Anton Romanov
  anton@rmnv.ru
###

'use strict'

PASSY_CLASS       = 'passy'
LINK_CLASS        = PASSY_CLASS  + '__trigger'
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

  _setInputType: (oldInput, type, where) ->
    newInput = oldInput.remove()
    newInput.attr('type', type)
    where.prepend(newInput)
    return newInput


  _setLinkTitle: (link, type, o) ->
    title = if type is TYPES[0] then o.titleofhide else o.titleofshow
    link.attr('title', title)
    return link

  # a.passy__link
  _createLink: (insertAfter, o) ->
    tabindex = if o.tabindex then '' else ' tabindex="-1"'
    link = $('<a'+tabindex+' class="'+LINK_CLASS+'" href="#'+o.hash+'"></a>')
    link.insertAfter(insertAfter)
    return link

  # i.passy__icon
  _createIcon: (where) ->
    icon = $('<i class="'+ICON_CLASS+'">')
    where.prepend(icon)
    return icon

  # toggle passy__icon_closed / passy__icon_opened
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
      oldType = [newType, newType = oldType][0] # var reverse
    return newType


  _setLinkBinds: (link, data) ->
    o = data.options; info = data.info; node = data.node
    link.on 'click.passy', (event) ->
      self.type('toggle', node.input)
      event.preventDefault()
    # for isHasFocus = true
    link.on 'mousedown.passy', ->
      info.isTriggerClick = true
      true
    link.on 'mouseup.passy', ->
      info.isTriggerClick = false
      true
    unless o.tabindex
      # remove outline for trigger when tabindex="-1"
      link.on 'focus.passy', ->
        $(this).blur()
    return link



  _setFocusBinds: (input, info) ->
    input.on 'focusin.passy', ->
      info.isHasFocus = true
      true
    input.on 'focusout.passy', ->
      unless info.isTriggerClick
        info.isHasFocus = false
        true


    return input






  _setType: (type, data) ->
    node = data.node; info = data.info; o = data.options

    node.link = self._setLinkTitle(node.link, type, o)
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
            defaulttype: 'text' # text/password
            titleofshow: 'Show simbols'
            titleofhide: 'Hide simbols'
            hashonhover: 'passyriot'
            tabindex:    false
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
      node.link.remove()
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
    node.link     = self._createLink(node.input, o)
    node.icon     = self._createIcon(node.link)
    self._setLinkBinds(data.node.link, data)
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


