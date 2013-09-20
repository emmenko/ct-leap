(function() {
  (function($, window) {
    var body, config, controller, document, lastGesture, leapConfig, pointer, positionFingerLeft, positionFingerTop;
    document = window.document;
    body = $("body");
    controller = new Leap.Controller({
      enableGestures: true
    });
    lastGesture = 0;
    leapConfig = Reveal.getConfig().leap;
    config = {
      autoCenter: true,
      gestureDelay: 500,
      naturalSwipe: true,
      pointerColor: '#00aaff',
      pointerOpacity: 0.7,
      pointerSize: 15,
      pointerTolerance: 120
    };
    positionFingerTop = 0;
    positionFingerLeft = 0;
    if (leapConfig) {
      _.extend(config, leapConfig);
    }
    pointer = $('<div>');
    pointer.attr("id", "leap");
    pointer.css({
      "position": "absolute",
      "visibility": "hidden",
      "z-index": 50,
      "opacity": config.pointerOpacity,
      "background-color": config.pointerColor
    });
    pointer.appendTo("body");
    controller.on("frame", function(frame) {
      var action, entered, enteredPosition, gesture, now, size, tappedElement, tipPosition, x, y;
      now = new Date().getTime();
      if (frame.fingers.length > 0 && frame.fingers.length < 3) {
        size = -3 * frame.fingers[0].tipPosition[2];
        if (size < config.pointerSize) {
          size = config.pointerSize;
        }
        tipPosition = frame.fingers[0].tipPosition;
        if (config.autoCenter) {
          if (!entered) {
            entered = true;
            enteredPosition = frame.fingers[0].tipPosition;
          }
          positionFingerTop = (-1 * ((tipPosition[1] - enteredPosition[1]) * body.height() / config.pointerTolerance)) + (body.height() / 2);
          positionFingerLeft = ((tipPosition[0] - enteredPosition[0]) * body.width() / config.pointerTolerance) + (body.width() / 2);
        } else {
          positionFingerTop = (1 - ((tipPosition[1] - 50) / config.pointerTolerance)) * body.height();
          positionFingerLeft = (tipPosition[0] * body.width() / config.pointerTolerance) + (body.width() / 2);
        }
        pointer.css({
          "width": "" + size + "px",
          "height": "" + size + "px",
          "border-radius": "" + (size - 5) + "px",
          "visibility": "visible",
          "top": "" + positionFingerTop + "px",
          "left": "" + positionFingerLeft + "px"
        });
      } else {
        entered = false;
        pointer.css({
          "visibility": "hidden"
        });
      }
      if (frame.gestures.length > 0 && (now - lastGesture) > config.gestureDelay) {
        gesture = frame.gestures[0];
        if (frame.hands.length === 1) {
          if (frame.fingers.length > 2 && gesture.type === 'swipe') {
            x = gesture.direction[0];
            y = gesture.direction[1];
            if (Math.abs(x) > Math.abs(y)) {
              if (x > 0) {
                if (config.naturalSwipe) {
                  Reveal.left();
                } else {
                  Reveal.right();
                }
              } else {
                if (config.naturalSwipe) {
                  Reveal.right();
                } else {
                  Reveal.left();
                }
              }
            } else {
              if (y > 0) {
                if (config.naturalSwipe) {
                  Reveal.down();
                } else {
                  Reveal.up();
                }
              } else {
                if (config.naturalSwipe) {
                  Reveal.up();
                } else {
                  Reveal.down();
                }
              }
            }
            lastGesture = now;
          }
        } else if (frame.hands.length === 2) {
          if (gesture.type === 'swipe') {
            if (gesture.direction[1] > 0) {
              if (!Reveal.isOverview()) {
                Reveal.toggleOverview();
              }
            } else {
              if (Reveal.isOverview()) {
                Reveal.toggleOverview();
              }
            }
          }
          lastGesture = now;
        }
        if (frame.fingers.length > 0 && frame.fingers.length < 3) {
          if (gesture.type === 'keyTap') {
            tappedElement = $(document.elementFromPoint(positionFingerLeft, positionFingerTop));
            action = tappedElement.data("action");
            if (action) {
              switch (action) {
                case "show-help":
                  return $("#helpScreen").css({
                    "z-index": 40,
                    "visibility": "visible"
                  });
                case "hide-help":
                  return $("#helpScreen").css({
                    "z-index": 0,
                    "visibility": "hidden"
                  });
              }
            }
          }
        }
      }
    });
    return controller.connect();
  })(jQuery, window);

}).call(this);
