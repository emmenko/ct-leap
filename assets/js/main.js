(function() {
  (function($, window) {
    var Canvas;
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
    Canvas = (function() {
      function Canvas(opts) {
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
        this.ctx.closePath();
        this.ctx.fill();
        this.ctx.lineWidth = this._options.lineWidth;
        this.imageData = this.ctx.getImageData(0, 0, container.width, container.height);
        this.animation = new Fx({
          duration: 3000,
          transition: Fx.Transitions.Expo.easeIn,
          link: "cancel",
          onStep: function(step) {
            return _this.draw(step / 100);
          }
        });
        this.animation.set = function(now) {
          var ret;
          ret = Fx.prototype.set.call(this, now);
          this.fireEvent("step", now);
          return ret;
        };
      }

      Canvas.prototype.draw = function(current) {
        $(this._options.el).data("progress", current * 100);
        this.ctx.putImageData(this.imageData, 0, 0);
        this.ctx.beginPath();
        this.ctx.arc(125, 125, 115, -this.startAngle, (this.circ * current) - this.startAngle, false);
        return this.ctx.stroke();
      };

      Canvas.prototype.start = function(start, end) {
        return this.animation.start(start, end);
      };

      Canvas.prototype.cancel = function() {
        return this.animation.cancel();
      };

      return Canvas;

    })();
    return window.Canvas = Canvas;
  })(jQuery, window);

  $(document).ready(function() {
    var loaders;
    loaders = $("canvas[data-id=loader]");
    return $.each(loaders, function(i, el) {
      var canvas, container, loader;
      loader = $(el);
      canvas = new Canvas({
        el: el,
        startAngle: loader.data("angle-start")
      });
      container = loader.closest("*[data-toggle=pointer]");
      return container.hover(function(evt) {
        var progress, target;
        canvas.cancel();
        target = $(evt.currentTarget);
        if (!target.hasClass("active")) {
          target.addClass("active");
          progress = target.find("canvas").data("progress");
          return canvas.start(progress, 90);
        }
      }, function(evt) {
        var progress, target;
        canvas.cancel();
        target = $(evt.currentTarget);
        if (target.hasClass("active")) {
          target.removeClass("active");
          progress = target.find("canvas").data("progress");
          return canvas.start(progress, 0);
        }
      });
    });
  });

}).call(this);
