###
 * Rigged Layer class: adds extra usual functions to a layer
###

## wonder wombat namespace
ww = ww || {}


ww.RiggedLayer = cc.Layer.extend (
  ## -attributes
  actors: []
  touchSink: null
  multiTouchSink: null
  accelerometerSink: null
  keyboardSink: null
  mouseSink: null

##-------------------------------------------------------------------
  ctor: () ->
    @winsize   = cc.director.getWinSize()
    @classNAME = "RiggedLayer"

    @_super()
    @init()

    if isDEBUG
      @_debugNode = cc.PhysicsDebugNode.create(ww.gameModel.world.space);
      @addChild(@_debugNode, 10);

    return ## end ctor

##-------------------------------------------------------------------
  init: () ->
    @_super()  ## layers have to call init super
    
    return true  ## end init

##-------------------------------------------------------------------
  addActor: (actor) ->
    if actor not in @actors
      @actors.push(actor)
      if actor.getSprite?
        sprite = actor.getSprite()
        if (sprite not in @getChildren())
          @addChild(sprite)

    return  ## end addActor

##-------------------------------------------------------------------
  setupTouchSink: (sink) ->
    
    if ( cc.sys.DESKTOP_BROWSER or (cc.sys.isNative and "touches" in cc.sys.capabilities) )
        @touchSink = sink

        listener = cc.EventListener.create(
          event: cc.EventListener.TOUCH_ONE_BY_ONE
          swallowTouches: true
          onTouchBegan: @onTouchBegan
          onTouchMoved: @onTouchMoved
          onTouchEnded: @onTouchEnded
        )

        cc.eventManager.addListener(listener , this)

    return  ## end setupTouchSink

##-------------------------------------------------------------------
  setupMultiTouchSink: (sink) ->

    if (cc.sys.isNative and "touches" in cc.sys.capabilities)
        @multiTouchSink = sink

        listener = cc.EventListener.create(
          event: cc.EventListener.TOUCH_ALL_AT_ONCE
          swallowTouches: true
          onTouchesBegan: @onTouchesBegan
          onTouchesMoved: @onTouchesMoved
          onTouchesEnded: @onTouchesEnded
        )

        cc.eventManager.addListener(listener , this)

    return  ## end setupMultiTouchSink

##-------------------------------------------------------------------
  setupAccelerometerSink: (sink) ->

    if (cc.sys.isNative and "accelerometer" in cc.sys.capabilities) 
        @accelerometerSink = sink

        cc.inputManager.setAccelerometerInterval(1/60)
        cc.inputManager.setAccelerometerEnabled(true)

        listener = cc.EventListener.create(
          event: cc.EventListener.ACCELERATION
          swallowTouches: true
          callback: @onAccelerometerCallback
        )

        cc.eventManager.addListener(listener , this)

    return  ## end setupAccelerometerSink

##-------------------------------------------------------------------
  setupKeyboardSink: (sink) ->

    if ( cc.sys.DESKTOP_BROWSER or (cc.sys.isNative and "keyboard" in cc.sys.capabilities) )
        @keyboardSink = sink
        listener = cc.EventListener.create(
          event: cc.EventListener.KEYBOARD
          swallowTouches: true
          onKeyPressed: @onKeyPressed
          onKeyReleased: @onKeyReleased
        )

        cc.eventManager.addListener(listener , this)

    return  ## end setupKeyboardSink

##-------------------------------------------------------------------
  setupMouseSink: (sink) ->

    if (cc.sys.isNative and "mouse" in cc.sys.capabilities)
        @mouseSink = sink
        listener = cc.EventListener.create(
          event: cc.EventListener.KEYBOARD
          swallowTouches: true
          onMouseDown: @onMouseDown
          onMouseUp: @onMouseUp
          onMouseMove: @onMouseMove
          onMouseScroll: @onMouseScroll
        )

        cc.eventManager.addListener(listener , this)

    return  ## end setupMouseSink

##-------------------------------------------------------------------
  onTouchBegan: (touch, event) ->
    if touchSink?
      touhSink.onTouchBegan(touch, event)

    # pos = touch.getLocation()
    # target = event.getCurrentTarget()
    # cc.log("Touch Began X: "+pos.x+"& Y: "+pos.y)

    return true

##-------------------------------------------------------------------
  onTouchMoved: (touch, event) ->
    if touchSink?
      touhSink.onTouchMoved(touch, event)

    # pos = touch.getLocation()
    # target = event.getCurrentTarget()
    # cc.log("Touch Moved X: "+pos.x+"& Y: "+pos.y)

    return true

##-------------------------------------------------------------------
  onTouchEnded: (touch, event) ->
    if touchSink?
      touhSink.onTouchEnded(touch, event)

    # pos = touch.getLocation()
    # target = event.getCurrentTarget()
    # cc.log("Touch Ended X: "+pos.x+"& Y: "+pos.y)

    return true

##-------------------------------------------------------------------
  onTouchesBegan: (touches, event) ->
    if multiTouhSink?
      multiTouhSink.onTouchesBegan(touches, event)

    # pos = (t.getLocation() for t in touches)
    # target = event.getCurrentTarget()
    # cc.log("Touches Began X: "+pos[0].x+"& Y: "+pos[0].y)

    return true

##-------------------------------------------------------------------
  onTouchesMoved: (touches, event) ->
    if multiTouhSink?
      multiTouhSink.onTouchesMoved(touches, event)

    # pos = (t.getLocation() for t in touches)
    # target = event.getCurrentTarget()
    # cc.log("Touches Moved X: "+pos[0].x+"& Y: "+pos[0].y)

    return true

##-------------------------------------------------------------------
  onTouchesEnded: (touches, event) ->
    if multiTouhSink?
      multiTouhSink.onTouchesEnded(touches, event)

    # pos = (t.getLocation() for t in touches)
    # target = event.getCurrentTarget()
    # cc.log("Touches Ended X: "+pos[0].x+"& Y: "+pos[0].y)

    return true

##-------------------------------------------------------------------
  onAccelerometerCallback: (accelEvent, event) ->
    if accelerometerSink?
      accelerometerSink.onAccelerometerCallback(accelEvent, event)

    # accelX = accelEvent.x
    # accelY = accelEvent.y
    # accelZ = accelEvent.z
    # target = event.getCurrentTarget()
    # cc.log("Accelerometer X: "+accelX+"& Y: "+accelY+"& Y: "+accelZ)

    return true

##-------------------------------------------------------------------
  onKeyPressed: (keyCode, event) ->
    if keyboardSink?
      keyboardSink.onKeyPressed(keyCode, event)

    # key = keyCode.toString()
    # target = event.getCurrentTarget()
    # cc.log("Key with keycode %d pressed", key)

    return true
      
##-------------------------------------------------------------------
  onKeyReleased: (keyCode, event) ->
    if keyboardSink?
      keyboardSink.onKeyReleased(keyCode, event)

    # key = keyCode.toString()
    # target = event.getCurrentTarget()
    # cc.log("Key with keycode %d released", key)

    return true

##-------------------------------------------------------------------
  onMouseDown: (event) ->
    if mouseSink?
      mouseSink.onMouseDown(event)

    # mKey = event.getMouseButton()
    # target = event.getCurrentTarget()
    # cc.log("Mouse Down detected, Key: " + mKey)

    return true

##-------------------------------------------------------------------
  onMouseUp: (event) ->
    if mouseSink?
      mouseSink.onMouseUp(event)

    # mKey = event.getMouseButton()
    # target = event.getCurrentTarget()
    # cc.log("Mouse Up detected, Key: " + mKey)

    return true

##-------------------------------------------------------------------
  onMouseMove: (event) ->
    if mouseSink?
      mouseSink.onMouseMove(event)

    # x = event.getCursorX()
    # y = event.getCursorY()
    # target = event.getCurrentTarget()
    # cc.log("Mouse Position X: "+x+"& Y: "+y)

    return true

##-------------------------------------------------------------------
  onMouseScroll: (event) ->
    if mouseSink?
      mouseSink.onMouseScroll(event)

    # x = event.getScrollX()
    # y = event.getScrollY()
    # target = event.getCurrentTarget()
    # cc.log("Mouse Scroll X: "+x+"& Y: "+y)

    return true  


)