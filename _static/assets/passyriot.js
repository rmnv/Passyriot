/*
  Passyriot
  https://github.com/rmnv/Passyriot

  jQuery plugin for password preview

  @requires jQuery (1.7.2 or later)
  @author Anton Romanov
  @copyright 2013 Anton Romanov (rmnv.ru)
  @license MIT
*/


(function() {
  'use strict';
  var ICON_CLASS, ICON_CLOSED_CLASS, ICON_OPENED_CLASS, INPUT_CLASS, PASSY_CLASS, TRIGGER_CLASS, TYPES, self;

  PASSY_CLASS = 'passy';

  TRIGGER_CLASS = PASSY_CLASS + '__trigger';

  INPUT_CLASS = PASSY_CLASS + '__input';

  ICON_CLASS = PASSY_CLASS + '__icon';

  ICON_CLOSED_CLASS = ICON_CLASS + '_closed';

  ICON_OPENED_CLASS = ICON_CLASS + '_opened';

  TYPES = ['text', 'password'];

  self = {
    /*
    toggle type of input: password/text
    */

    _setInputType: function(input, type, prepend) {
      prepend.prepend(input.detach().attr('type', type));
      return input;
    },
    /*
    Toggle «Show symbols» / «Hide symbols» in title
    */

    _setTitle: function(trigger, type, o) {
      var title;
      title = type === TYPES[0] ? o.titleofhide : o.titleofshow;
      return trigger.attr('title', title);
    },
    /*
    Create span.passy__trigger
    */

    _createTrigger: function(insertAfter) {
      var trigger;
      trigger = $('<span class="' + TRIGGER_CLASS + '"></span>');
      return trigger.insertAfter(insertAfter);
    },
    /*
    Create i.passy__icon
    */

    _createIcon: function(prepend, o) {
      var icon;
      icon = $('<i class="' + o.iconclass + '">');
      prepend.prepend(icon);
      return icon;
    },
    /*
    Toggle passy__icon_closed / passy__icon_opened
    */

    _setIconClass: function(icon, type, o) {
      var newClass, oldClass;
      oldClass = o.iconclosedclass;
      newClass = o.iconopenedclass;
      if (type === TYPES[0]) {
        oldClass = [newClass, newClass = oldClass][0];
      }
      icon.removeClass(oldClass).addClass(newClass);
      return icon;
    },
    /*
    Pass «text», get «password»
    */

    _getNextType: function(nowType) {
      var newType, oldType;
      oldType = TYPES[0];
      newType = TYPES[1];
      if (nowType === newType) {
        oldType = [newType, newType = oldType][0];
      }
      return newType;
    },
    /*
    On eye click
    */

    _setTriggerBinds: function(trigger, data) {
      var info, node, o;
      node = data.node;
      info = data.info;
      o = data.options;
      trigger.on('click.passy', function(event) {
        o.onTriggerClick(data);
        self.type('toggle', node.input);
        node.input.focus();
        return event.preventDefault();
      });
      trigger.on('mousedown.passy', function() {
        info.isTriggerClick = true;
        return true;
      });
      trigger.on('mouseup.passy', function() {
        info.isTriggerClick = false;
        return true;
      });
      return trigger;
    },
    /*
    On fucus / blur
    */

    _setFocusBinds: function(input, data) {
      var info, o;
      info = data.info;
      o = data.options;
      input.on('focusin.passy', function() {
        info.isHasFocus = true;
        return true;
      });
      input.on('focusout.passy', function() {
        if (!info.isTriggerClick) {
          info.isHasFocus = false;
          if (o.hideonblur && o.defaulttype === 'password') {
            self._setType('password', data);
          }
        }
        return true;
      });
      return input;
    },
    _setType: function(type, data) {
      var info, node, o;
      node = data.node;
      info = data.info;
      o = data.options;
      node.trigger = self._setTitle(node.trigger, type, o);
      node.icon = self._setIconClass(node.icon, type, o);
      node.input = self._setInputType(node.input, type, node.wrapper);
      info.nowType = type;
      info.nextType = self._getNextType(info.nowType);
      o.onTypeChange(data);
      return data;
    },
    /*
    Public method .passyriot('type')
    */

    type: function(type, input) {
      if (input == null) {
        input = this;
      }
      return input.each(function() {
        var data, info, o;
        data = $(this).parent().data('passy');
        info = data.info;
        o = data.options;
        if (!type) {
          return info.nowType;
        } else if (type === 'toggle') {
          return self._setType(info.nextType, data);
        } else if (type === info.nextType || info.isFirst) {
          info.isFirst = false;
          return self._setType(type, data);
        }
      });
    },
    init: function(userOptions) {
      return this.each(function() {
        var data, defaultOptions, input, node, o, options, startTag, startType;
        input = $(this);
        if (!input.parents('.' + PASSY_CLASS).length) {
          startTag = input.prop('tagName').toLowerCase();
          startType = input.prop('type');
          if (startTag === 'input' && startType === 'password') {
            defaultOptions = {
              defaulttype: 'password',
              titleofshow: 'Show simbols',
              titleofhide: 'Hide simbols',
              hideonblur: false,
              iconclass: ICON_CLASS,
              iconopenedclass: ICON_OPENED_CLASS,
              iconclosedclass: ICON_CLOSED_CLASS,
              onTriggerClick: function() {},
              onTypeChange: function() {}
            };
            options = $.extend({}, defaultOptions, userOptions, input.data());
            data = self._constructor(input, options);
            node = data.node;
            o = data.options;
            if (o.defaulttype === 'text' && o.hideonblur) {
              o.defaulttype = 'password';
            }
            self.type(o.defaulttype, node.input);
            return input;
          }
        }
      });
    },
    destroy: function() {
      return this.each(function() {
        var data, node;
        data = $(this).parent().data('passy');
        node = data.node;
        self._setType('password', data);
        node.trigger.remove();
        node.input.off('.passy').unwrap(node).removeClass(INPUT_CLASS);
        return $(this);
      });
    },
    _constructor: function(input, options) {
      var data, info, node, o, wrapper;
      wrapper = input.wrap('<span class="' + PASSY_CLASS + '">').parent();
      wrapper.data('passy', {
        options: options,
        node: {},
        info: {}
      });
      data = wrapper.data('passy');
      node = data.node;
      o = data.options;
      info = data.info;
      info.nowType = o.defaulttype;
      info.isFirst = true;
      node.wrapper = wrapper;
      node.input = input.addClass(INPUT_CLASS);
      node.trigger = self._createTrigger(node.input);
      node.icon = self._createIcon(node.trigger, o);
      self._setTriggerBinds(data.node.trigger, data);
      self._setFocusBinds(node.input, data);
      return data;
    }
  };

  /*
  Difficult auto initialization
  */


  $(function() {
    return $('.passyriot:not([data-auto="false"])').passyriot();
  });

  $.fn.passyriot = function(method) {
    if (self[method]) {
      return self[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return self.init.apply(this, arguments);
    } else {
      return $.error('Blah! ' + method + ' not found');
    }
  };

}).call(this);
