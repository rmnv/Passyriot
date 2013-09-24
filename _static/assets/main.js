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

  jQuery(function($) {});

}).call(this);
