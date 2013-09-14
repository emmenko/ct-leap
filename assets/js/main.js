(function() {
  (function() {
    return Reveal.initialize({
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
  })();

}).call(this);
