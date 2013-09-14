# Leap Motion integration for Reveal.js.
# James Sun  [sun16]
# Rory Hardy [gneatgeek]

# Modified by:
# Nicola Molinari [emmenko]


(->
  body        = $("body")
  controller  = new Leap.Controller enableGestures: true
  lastGesture = 0
  leapConfig  = Reveal.getConfig().leap
  config      =
    autoCenter       : true      # Center pointer around detected position.
    gestureDelay     : 500       # How long to delay between gestures.
    naturalSwipe     : true      # Swipe as if it were a touch screen.
    pointerColor     : '#00aaff' # Default color of the pointer.
    pointerOpacity   : 0.7       # Default opacity of the pointer.
    pointerSize      : 15        # Default minimum height/width of the pointer.
    pointerTolerance : 120       # Bigger = slower pointer.
  positionFingerTop  = 0
  positionFingerLeft = 0

  # Merge user defined settings with defaults
  _.extend(config, leapConfig) if leapConfig

  pointer = $('<div>')
  pointer.attr("id", "leap")
  pointer.css
    "position"        : "absolute"
    "visibility"      : "hidden"
    "z-index"         : 50
    "opacity"         : config.pointerOpacity
    "background-color": config.pointerColor
  pointer.appendTo("body")

  # Leap's loop
  controller.on "frame", (frame)->
    # Timing code to rate limit gesture execution
    now = new Date().getTime()

    # Pointer: 1 to 2 fingers. Strictly one finger works but may cause innaccuracies.
    # The innaccuracies were observed on a development model and may not be an issue with consumer models.
    if frame.fingers.length > 0 and frame.fingers.length < 3
      # Invert direction and multiply by 3 for greater effect.
      size = -3 * frame.fingers[0].tipPosition[2]

      if size < config.pointerSize
        size = config.pointerSize

      tipPosition = frame.fingers[0].tipPosition
      if config.autoCenter

        # Check whether the finger has entered the z range of the Leap Motion. Used for the autoCenter option.
        if not entered
          entered         = true
          enteredPosition = frame.fingers[0].tipPosition

        positionFingerTop =
          (-1 * (( tipPosition[1] - enteredPosition[1] ) * body.height() / config.pointerTolerance )) +
            ( body.height() / 2 )

        positionFingerLeft =
          (( tipPosition[0] - enteredPosition[0] ) * body.width() / config.pointerTolerance ) +
            ( body.width() / 2 )
      else
        positionFingerTop  = ( 1 - (( tipPosition[1] - 50) / config.pointerTolerance )) *
          body.height()

        positionFingerLeft = ( tipPosition[0] * body.width() / config.pointerTolerance ) +
          ( body.width() / 2 )

      pointer.css
        "width"           : "#{size}px"
        "height"          : "#{size}px"
        "border-radius"   : "#{size - 5}px"
        "visibility"      : "visible"
        "top"             : "#{positionFingerTop}px"
        "left"            : "#{positionFingerLeft}px"

    else
      # Hide pointer on exit
      entered = false
      pointer.css("visibility": "hidden")

    # Gestures
    if frame.gestures.length > 0 and (now - lastGesture) > config.gestureDelay
      gesture = frame.gestures[0]

      # One hand gestures
      if frame.hands.length is 1
        # Swipe gestures. 3+ fingers.
        if frame.fingers.length > 2 and gesture.type is 'swipe'
          # Define here since some gestures will throw undefined for these.
          x = gesture.direction[0]
          y = gesture.direction[1]

          # Left/right swipe gestures
          if Math.abs( x ) > Math.abs( y )
            if x > 0
              if config.naturalSwipe then Reveal.left() else Reveal.right()
            else
              if config.naturalSwipe then Reveal.right() else Reveal.left()

          # Up/down swipe gestures
          else
            if y > 0
              if config.naturalSwipe then Reveal.down() else Reveal.up()
            else
              if config.naturalSwipe then Reveal.up() else Reveal.down()

          lastGesture = now

      # Two hand gestures
      else if frame.hands.length is 2
        # Upward/downwards two hand swipe gesture
        if gesture.type is 'swipe'
          if gesture.direction[1] > 0
            # Upwards: toggle only if not already in overview mode
            Reveal.toggleOverview() unless Reveal.isOverview()
          else
            # Downwards: toggle only if already in overview mode
            Reveal.toggleOverview() if Reveal.isOverview()

        lastGesture = now

      # KeyTap gesture for click events (1 to 2 fingers)
      if frame.fingers.length > 0 and frame.fingers.length < 3
        if gesture.type is 'keyTap'
          # get element based on fingers position
          tappedElement = $(document.elementFromPoint(positionFingerLeft, positionFingerTop))
          action = tappedElement.data("action")
          if action
            switch action
              when "show-help"
                $("#helpScreen").css("z-index": 40, "visibility": "visible")
              when "hide-help"
                $("#helpScreen").css("z-index": 0, "visibility": "hidden")

  controller.connect()
)()
