(($, window)->
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


  class Canvas
    constructor: (opts)->
      @_options = $.extend
        el: $("#canvas")
        strokeStyle: "#FFFFFF"
        lineCap: "square"
        lineWidth: 8.0
        startAngle: 90
      , opts

      container = @_options.el
      @ctx = container.getContext("2d")
      @circ = Math.PI * 2
      @startAngle = @_options.startAngle * Math.PI / 180

      @ctx.beginPath()
      @ctx.strokeStyle = @_options.strokeStyle
      @ctx.lineCap = @_options.lineCap
      @ctx.closePath()
      @ctx.fill()
      @ctx.lineWidth = @_options.lineWidth

      @imageData = @ctx.getImageData(0, 0, container.width, container.height)

      @animation = new Fx
        duration: 3000
        transition: Fx.Transitions.Expo.easeIn
        link: "cancel"
        onStep: (step)=> @draw(step / 100)

      @animation.set = (now)->
        ret = Fx.prototype.set.call(this, now)
        this.fireEvent("step", now)
        ret

    draw: (current)->
      $(@_options.el).data("progress", current * 100)
      @ctx.putImageData(@imageData, 0, 0)
      @ctx.beginPath()
      # arc(x, y, radius, angleStart, angleEnd, direction)
      @ctx.arc(125, 125, 115, -@startAngle, ((@circ) * current) - @startAngle, false)
      @ctx.stroke()

    start: (start, end)->
      @animation.start(start, end)

    cancel: -> @animation.cancel()

  window.Canvas = Canvas

)(jQuery, window)

$(document).ready ->

  loaders = $("canvas[data-id=loader]")
  $.each loaders, (i, el)->
    loader = $(el)
    canvas = new Canvas el: el, startAngle: loader.data("angle-start")

    container = loader.closest("*[data-toggle=pointer]")
    container.hover (evt)->
      canvas.cancel()
      target = $(evt.currentTarget)
      if not target.hasClass("active")
        target.addClass("active")
        progress = target.find("canvas").data("progress")
        canvas.start(progress, 90)
    , (evt)->
      canvas.cancel()
      target = $(evt.currentTarget)
      if target.hasClass("active")
        target.removeClass("active")
        progress = target.find("canvas").data("progress")
        canvas.start(progress, 0)