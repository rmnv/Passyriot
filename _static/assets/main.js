(function() {
  window.log = function() {
    log.history = log.history || [];
    log.history.push(arguments);
    if (this.console) {
      return console.log(Array.prototype.slice.call(arguments));
    }
  };

  window.after = function(ms, fn) {
    return setTimeout(fn, ms);
  };

  jQuery(function($) {
    var hint, hintHideClass, input, pussy, pussyOpenedClass;
    pussy = $('.pussyriot');
    pussyOpenedClass = 'pussyriot_opened';
    hint = $('.preview__hint');
    hintHideClass = 'preview__hint_hide';
    input = $('input[type="password"]');
    return input.passyriot({
      defaulttype: 'password',
      titleofshow: 'Показать символы',
      titleofhide: 'Скрыть символы',
      iconclass: 'svg-eye',
      iconopenedclass: 'svg-eye_opened',
      iconclosedclass: 'svg-eye_closed',
      onTypeChange: function(data) {
        if (data.info.nowType === 'text') {
          pussy.addClass(pussyOpenedClass);
          return hint.addClass(hintHideClass);
        } else {
          pussy.removeClass(pussyOpenedClass);
          return hint.removeClass(hintHideClass);
        }
      }
    });
  });

}).call(this);
