(function() {
  (function($, window) {
    var Loader;
    Reveal.initialize({
      width: "100%",
      height: "100%",
      margin: -0.1,
      minScale: 0,
      maxScale: 1.0,
      controls: false,
      progress: false,
      history: false,
      keyboard: true,
      touch: true,
      overview: true,
      center: true,
      loop: false,
      rtl: false,
      autoSlide: 0,
      mouseWheel: false,
      transition: 'linear',
      transitionSpeed: 'default',
      backgroundTransition: 'slide',
      leap: {
        autoCenter: false,
        gestureDelay: 500,
        naturalSwipe: true,
        pointerColor: '#d80000',
        pointerOpacity: 0.5,
        pointerSize: 15,
        pointerTolerance: 120
      },
      dependencies: [
        {
          src: 'assets/plugin/leap/leap.js',
          async: true
        }
      ]
    });
    Loader = (function() {
      function Loader(opts) {
        var container,
          _this = this;
        this._options = $.extend({
          el: $("#canvas"),
          strokeStyle: "#FFFFFF",
          lineCap: "square",
          lineWidth: 8.0,
          startAngle: 90
        }, opts);
        container = this._options.el;
        this.ctx = container.getContext("2d");
        this.circ = Math.PI * 2;
        this.startAngle = this._options.startAngle * Math.PI / 180;
        this.ctx.beginPath();
        this.ctx.strokeStyle = this._options.strokeStyle;
        this.ctx.lineCap = this._options.lineCap;
        this.ctx.lineWidth = this._options.lineWidth;
        this.ctx.closePath();
        this.ctx.fill();
        this.imageData = this.ctx.getImageData(0, 0, container.width, container.height);
        this.animation = new Fx({
          duration: 3000,
          transition: Fx.Transitions.Quint.easeInOut,
          link: "cancel",
          onStep: function(step) {
            return _this.draw(step / 100);
          },
          onComplete: function() {
            var el, indexSlide;
            el = $(_this._options.el);
            if (el.data("progress") > 0) {
              indexSlide = el.data("target-index");
              return Reveal.slide(null, indexSlide);
            }
          }
        });
        this.animation.set = function(now) {
          var ret;
          ret = Fx.prototype.set.call(this, now);
          this.fireEvent("step", now);
          return ret;
        };
      }

      Loader.prototype.draw = function(current) {
        $(this._options.el).data("progress", current * 100);
        this.ctx.putImageData(this.imageData, 0, 0);
        this.ctx.beginPath();
        this.ctx.arc(125, 125, 115, -this.startAngle, (this.circ * current) - this.startAngle, false);
        return this.ctx.stroke();
      };

      Loader.prototype.start = function(start, end) {
        return this.animation.start(start, end);
      };

      Loader.prototype.cancel = function() {
        return this.animation.cancel();
      };

      return Loader;

    })();
    return window.Loader = Loader;
  })(jQuery, window);

  $(document).ready(function() {
    var loaders;
    loaders = $("canvas[data-id=loader]");
    return $.each(loaders, function(i, el) {
      var container, loader, loaderEl;
      loaderEl = $(el);
      loader = new Loader({
        el: el,
        startAngle: loaderEl.data("angle-start")
      });
      container = loaderEl.closest("*[data-toggle=pointer]");
      return container.hover(function(evt) {
        var progress;
        loader.cancel();
        if (!container.hasClass("active")) {
          container.addClass("active");
          progress = container.find("canvas[data-id=loader]").data("progress");
          return loader.start(progress, 90);
        }
      }, function(evt) {
        var progress;
        loader.cancel();
        if (container.hasClass("active")) {
          container.removeClass("active");
          progress = container.find("canvas[data-id=loader]").data("progress");
          return loader.start(progress, 0);
        }
      });
    });
  });

}).call(this);
