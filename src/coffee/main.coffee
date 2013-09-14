(->
  # Initialite reveal.js
  Reveal.initialize
    # The "normal" size of the presentation, aspect ratio will be preserved when the presentation is scaled to fit different resolutions.
    # Can be specified using percentage units.
    width                 : "100%"
    height                : "100%"
    margin                : -0.1         # Factor of the display size that should remain empty around the content
    minScale              : 0            # Bounds for smallest/largest possible scale to apply to content
    maxScale              : 1.0
    controls              : false        # Display controls in the bottom right corner
    progress              : false        # Display a presentation progress bar
    history               : false        # Push each slide change to the browser history
    keyboard              : true         # Enable keyboard shortcuts for navigation
    touch                 : true         # Enable touch events for navigation
    overview              : true         # Enable the slide overview mode
    center                : true         # Vertical centering of slides
    loop                  : false        # Loop the presentation
    rtl                   : false        # Change the presentation direction to be RTL
    autoSlide             : 0            # Number of ms between automatically proceeding to the next slide,
                                          # Disabled when set to 0, this value can be overwritten by using a data-autoslide attribute on your slides
    mouseWheel            : false        # Enable slide navigation via mouse wheel
    transition            : 'linear'     # Transition style [default/cube/page/concave/zoom/linear/fade/none]
    transitionSpeed       : 'default'    # Transition speed [default/fast/slow]
    backgroundTransition  : 'slide'      # Transition style for full page backgrounds [default/linear/none]

    leap:
      autoCenter          : false        # Center the pointer based on where you put your finger into the leap motions detection field
      gestureDelay        : 500          # Delay between gestures in ms
      naturalSwipe        : true         # Swipe as though you were touching a touch screen. Set to false to invert
      pointerColor        : '#d80000'    # Red pointer
      pointerOpacity      : 0.5          # Set pointer opacity to 0.5
      pointerSize         : 15           # The minimum height and width of the pointer
      pointerTolerance    : 120          # Bigger = slower pointer

    dependencies: [
      { src: 'assets/plugin/leap/leap.js', async: true }
    ]
)()