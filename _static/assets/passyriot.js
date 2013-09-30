/*
  input[type="password"] / input[type="text"]
  © 2013 by Anton Romanov
  anton@rmnv.ru
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
    _setSelect: function(input, start, end) {
      if (!end) {
        end = start;
      }
      return input.each(function() {
        var range;
        if (this.setSelectionRange) {
          this.focus();
          return this.setSelectionRange(start, end);
        } else if (this.createTextRange) {
          range = this.createTextRange();
          range.collapse(true);
          range.moveEnd("character", end);
          range.moveStart("character", start);
          range.select();
          return input.focus();
        }
      });
    },
    getSelect: function(input) {
      var CaretPos, Sel;
      CaretPos = 0;
      if (document.selection) {
        input.focus();
        Sel = document.selection.createRange();
        Sel.moveStart("character", -input.value.length);
        CaretPos = Sel.text.length;
      }
      if (input.selectionStart || input.selectionStart === 0) {
        CaretPos = input.selectionStart;
      }
      return CaretPos;
    },
    _setInputType: function(input, type, where) {
      where.prepend(input.detach().attr('type', type));
      return input;
    },
    _setTitle: function(trigger, type, o) {
      var title;
      title = type === TYPES[0] ? o.titleofhide : o.titleofshow;
      return trigger.attr('title', title);
    },
    _createTrigger: function(insertAfter) {
      var trigger;
      trigger = $('<span class="' + TRIGGER_CLASS + '"></span>');
      return trigger.insertAfter(insertAfter);
    },
    _createIcon: function(prepend) {
      var icon;
      icon = $('<i class="' + ICON_CLASS + '">');
      prepend.prepend(icon);
      return icon;
    },
    _setIconClass: function(icon, type) {
      var newClass, oldClass;
      oldClass = ICON_OPENED_CLASS;
      newClass = ICON_CLOSED_CLASS;
      if (type === TYPES[0]) {
        oldClass = [newClass, newClass = oldClass][0];
      }
      icon.removeClass(oldClass).addClass(newClass);
      return icon;
    },
    _getNextType: function(nowType) {
      var newType, oldType;
      oldType = TYPES[0];
      newType = TYPES[1];
      if (nowType === newType) {
        oldType = [newType, newType = oldType][0];
      }
      return newType;
    },
    _setTriggerBinds: function(trigger, data) {
      var info, node, o;
      o = data.options;
      info = data.info;
      node = data.node;
      trigger.on('click.passy', function(event) {
        self.type('toggle', node.input);
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
    _setFocusBinds: function(input, info) {
      input.on('focusin.passy', function() {
        info.isHasFocus = true;
        return true;
      });
      input.on('focusout.passy', function() {
        if (!info.isTriggerClick) {
          info.isHasFocus = false;
          return true;
        }
      });
      return input;
    },
    _setType: function(type, data) {
      var info, node, o;
      node = data.node;
      info = data.info;
      o = data.options;
      node.trigger = self._setTitle(node.trigger, type, o);
      node.icon = self._setIconClass(node.icon, type);
      node.input = self._setInputType(node.input, type, node.wrapper);
      self._setFocusBinds(node.input, info);
      info.nowType = type;
      info.nextType = self._getNextType(info.nowType);
      if (info.isHasFocus) {
        node.input.focus();
      }
      return data;
    },
    type: function(type, input) {
      if (input == null) {
        input = this;
      }
      return input.each(function() {
        var data, info, node, o;
        data = $(this).parent().data('passy');
        node = data.node;
        o = data.options;
        info = data.info;
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
        if (!data) {
          input = $(this);
          startTag = input.prop('tagName').toLowerCase();
          startType = input.prop('type');
          if (startTag === 'input' && startType === 'password') {
            defaultOptions = {
              defaulttype: 'password',
              titleofshow: 'Show simbols',
              titleofhide: 'Hide simbols',
              hashonhover: 'passyriot'
            };
            options = $.extend({}, defaultOptions, userOptions, input.data());
            data = self._constructor(input, options);
            node = data.node;
            o = data.options;
            self.type(o.defaulttype, node.input);
            return $(this);
          } else {
            return $.error(input + 'must be input[type="password"]');
          }
        }
      });
    },
    destroy: function() {
      return this.each(function() {
        var data, info, node, o;
        data = $(this).parent().data('passy');
        node = data.node;
        o = data.options;
        info = data.info;
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
      node.icon = self._createIcon(node.trigger);
      self._setTriggerBinds(data.node.trigger, data);
      return data;
    }
  };

  $(function() {
    return $('.passyriot:not([data-auto="false"])').passyriot();
  });

  $.fn.passyriot = function(method) {
    if (self[method]) {
      return self[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return self.init.apply(this, arguments);
    } else {
      return $.error(method + ' not found');
    }
  };

}).call(this);
