###
  Passyriot
  https://github.com/rmnv/Passyriot

  jQuery plugin for password preview

  @requires jQuery (1.7.2 or later)
  @author Anton Romanov
  @copyright 2013 Anton Romanov (rmnv.ru)
  @license MIT
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

  ###
  toggle type of input: password/text
  ###
  _setInputType: (input, type, prepend) ->
    prepend.prepend(input.detach().attr('type', type))
    input

  ###
  Toggle «Show symbols» / «Hide symbols» in title
  ###
  _setTitle: (trigger, type, o) ->
    title = if type is TYPES[0] then o.titleofhide else o.titleofshow
    trigger.attr('title', title)

  ###
  Create span.passy__trigger
  ###
  _createTrigger: (insertAfter) ->
    trigger = $('<span class="'+TRIGGER_CLASS+'"></span>')
    trigger.insertAfter(insertAfter)

  ###
  Create i.passy__icon
  ###
  _createIcon: (prepend, o) ->
    icon = $('<i class="'+o.iconclass+'">')
    prepend.prepend(icon)
    icon

  ###
  Toggle passy__icon_closed / passy__icon_opened
  ###
  _setIconClass: (icon, type, o) ->
    oldClass = o.iconclosedclass
    newClass = o.iconopenedclass
    if type is TYPES[0]
      oldClass = [newClass, newClass = oldClass][0] # var swap
    icon.removeClass(oldClass).addClass(newClass)
    return icon

  ###
  Pass «text», get «password»
  ###
  _getNextType: (nowType) ->
    oldType = TYPES[0]
    newType = TYPES[1]
    if nowType is newType
      oldType = [newType, newType = oldType][0]
    return newType

  ###
  On eye click
  ###
  _setTriggerBinds: (trigger, data) ->
    node = data.node; info = data.info; o = data.options
    trigger.on 'click.passy', (event) ->
      o.onTriggerClick(data)
      self.type('toggle', node.input)
      node.input.focus()
      event.preventDefault()
    # for isHasFocus === true
    trigger.on 'mousedown.passy', ->
      info.isTriggerClick = true
      true
    trigger.on 'mouseup.passy', ->
      info.isTriggerClick = false
      true
    trigger

  ###
  On fucus / blur
  ###
  _setFocusBinds: (input, data) ->
    info = data.info; o = data.options
    input.on 'focusin.passy', ->
      info.isHasFocus = true
      true
    input.on 'focusout.passy', ->
      unless info.isTriggerClick
        info.isHasFocus = false
        if o.hideonblur and o.defaulttype is 'password'
          self._setType('password', data)
      true
    input

  _setType: (type, data) ->
    node = data.node; info = data.info; o = data.options
    node.trigger  = self._setTitle(node.trigger, type, o)
    node.icon     = self._setIconClass(node.icon, type, o)
    node.input    = self._setInputType(node.input, type, node.wrapper)
    info.nowType  = type
    info.nextType = self._getNextType(info.nowType)
    o.onTypeChange(data)
    data

  ###
  Public method .passyriot('type')
  ###
  type: (type, input = @) ->
    input.each ->
      data = $(this).parent().data('passy')
      info = data.info; o = data.options
      # input.passyriot('type')
      unless type
        info.nowType
      # input.passyriot('type', 'toggle') or click
      else if type is 'toggle'
        self._setType(info.nextType, data)
      # input.passyriot('type', '...')
      else if type is info.nextType or info.isFirst
        info.isFirst = false
        self._setType(type, data)


  init: (userOptions) ->
    @each ->
      input = $(this)
      unless input.parents('.'+PASSY_CLASS).length
        startTag = input.prop('tagName').toLowerCase()
        startType = input.prop('type')
        if startTag is 'input' and startType is 'password'
          defaultOptions =
            defaulttype: 'password' # text/password
            titleofshow: 'Show simbols'
            titleofhide: 'Hide simbols'
            hideonblur: false
            iconclass: ICON_CLASS
            iconopenedclass: ICON_OPENED_CLASS
            iconclosedclass: ICON_CLOSED_CLASS
            onTriggerClick: ->
            onTypeChange: ->
          options = $.extend {},
            defaultOptions, userOptions, input.data()
          data = self._constructor(input, options)
          node = data.node; o = data.options
          if o.defaulttype is 'text' and o.hideonblur
            o.defaulttype = 'password'
          self.type(o.defaulttype, node.input)
          input

  destroy: () ->
    @each ->
      data = $(this).parent().data('passy')
      node = data.node
      self._setType('password', data)
      node.trigger.remove()
      node.input.off('.passy').unwrap(node).removeClass(INPUT_CLASS)
      $(this)

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
    node.icon     = self._createIcon(node.trigger, o)
    self._setTriggerBinds(data.node.trigger, data)
    self._setFocusBinds(node.input, data)
    data

###
Difficult auto initialization
###
$ ->
  $('.passyriot:not([data-auto="false"])').passyriot()

$.fn.passyriot = (method) ->
  if self[method]
    self[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is 'object' or not method
    self.init.apply this, arguments
  else
    $.error 'Blah! ' + method + ' not found'


