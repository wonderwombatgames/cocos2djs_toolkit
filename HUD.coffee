###
 * overlay displya classes
###

## wonder wombat namespace
ww = ww || {}


##======== Score label class
ww.Score = cc.Class.extend (

##-------------------------------------------------------------------
  ##  Constructor
  ##    @param {cc.node}
  ##    @param {string}
  ##    @param {number}
  ##    @param {cc.color}
  ##    @param {cc.p}
  ##    @param {number}
  ctor: (parent, fontName, fontSize, fontColor, position, prefix, value) ->
    @init(parent, fontName, fontSize, fontColor, position, prefix, value) 
    @classNAME = "HudScore"

    return ## end ctor

##-------------------------------------------------------------------
  init: (parent, fontName, fontSize, fontColor, position, prefix, val) ->
  	##default for last param
    @value = val || 0
    @initValue = @value
    @prefix = prefix
    

    path = "res/fonts/"
    ext = ".ttf"
    if (cc.sys.isNative) and (cc.sys.OS_ANDROID)
      fontPath = path + fontName + ext
      @hudLabel = new cc.LabelTTF("", fontPath, fontSize)
    else
      @hudLabel = new cc.LabelTTF("", fontName, fontSize)

    @displayVal()
    @hudLabel.setPosition(position)
    @hudLabel.setColor(fontColor)
    @hudLabel.retain()

    parent.addChild(@hudLabel)

    return ## end init

##-------------------------------------------------------------------
  showVal: (show) ->
    @hudLabel.setVisible(show)

    return ## end of showVal

##-------------------------------------------------------------------
  displayVal: () ->
    score = @prefix + " " + @value
    @hudLabel.setString(score);

    return ## end displayVal

##-------------------------------------------------------------------
  resetVal: (val) ->
    val = val || @initValue
    @value = val
    @displayVal()

    return ## end resetVal

##-------------------------------------------------------------------
  setVal: (val) ->
    @value = val
    @displayVal()

    return ## end setVal

##-------------------------------------------------------------------
  getVal: () ->
    return @value ## end of getVal

##-------------------------------------------------------------------
  increasVal: () ->
    @value++
    @displayVal()

    return @value ## end increasVal

##-------------------------------------------------------------------
  decreasVal: () ->
    if @value > 0
      @value--
      @displayVal()

    return @value ## end decreasVal

)

##======== Timer label class
ww.Timer = ww.Score.extend (
##-------------------------------------------------------------------
  ##  Constructor
  ##    @param {cc.node}
  ##    @param {string}
  ##    @param {number}
  ##    @param {cc.color}
  ##    @param {cc.p}
  ##    @param {number}
  ctor: (parent, fontName, fontSize, fontColor, position, prefix, value) ->
    @init(parent, fontName, fontSize, fontColor, position, prefix, value) 
    @classNAME = "HudTimer"

    return ## end ctor

##-------------------------------------------------------------------
  displayVal: () ->
    seconds = @value
    min = Math.floor(seconds/60)


    minStr = "00"+min
    minStr = minStr.substr(minStr.length-2, minStr.length-1)

    sec = Math.floor(seconds % 60)
    secStr = "00"+sec
    secStr = secStr.substr(secStr.length-2, secStr.length-1)

    timerStr = minStr + ":" + secStr
    @hudLabel.setString(timerStr)

    return ## displayVal

)


##======== Lifes display class
ww.Lifes = cc.Class.extend (

##-------------------------------------------------------------------
  ##  Constructor
  ##    @param {cc.node}
  ##    @param {number}
  ##    @param {cc.p}
  ##    @param {json}
  ##    @param {json}
  ctor: (parent, amount, position, activeObj, inactiveObj) ->
    @init(parent, amount, position, activeObj, inactiveObj) 
    @classNAME = "HudLifes"

    return ## end ctor

##-------------------------------------------------------------------
  init: (parent, amount, position, activeObj, inactiveObj) ->
    ##default for last param
    @value = amount || 0
    @initValue = @value

    @lifesNode = new cc.Node()
    parent.addChild(@lifesNode)
    @lifesDisplay = []

    @position = position
    @activeObj = activeObj
    @inactiveObj = inactiveObj
    @assemble()

    return ## end int()

##-------------------------------------------------------------------
  assemble: () ->
    offset = 1 - (@initValue % 2)
    lower = offset - (@initValue - (@initValue % 2))/2
    upper = (@initValue - (@initValue % 2))/2
    range = [lower..upper]

    for item in range
      elem = {}

      ndx = true
      elem[ndx] = ww.spriteFactory.createSimpleSprite(@activeObj.resource, @position)
      @lifesNode.addChild(elem[ndx])
      itemOffset = ( item + (offset/2) ) * (elem[ndx].getBoundingBox().width)
      itemPos = cc.p(@position.x + itemOffset, @position.y)

      elem[ndx].setPosition (itemPos)
      elem[ndx].setScale(@activeObj.scale)
      elem[ndx].setOpacity(@activeObj.opacity)
      elem[ndx].setVisible(true)

      ndx = false
      elem[ndx] = ww.spriteFactory.createSimpleSprite(@inactiveObj.resource, itemPos)
      @lifesNode.addChild(elem[ndx])
      elem[ndx].setScale(@inactiveObj.scale)
      elem[ndx].setOpacity(@inactiveObj.opacity)
      elem[ndx].setVisible(false)

      @lifesDisplay.push(elem)

    @lifesNode.setVisible(false)

    return ## end init

##-------------------------------------------------------------------
  showVal: (show) ->
    @lifesNode.setVisible(show)

    return ## end of showval

##-------------------------------------------------------------------
  displayVal: () ->
    ndx = 1
    for elem in @lifesDisplay
      active = (ndx <= @value)
      elem[active].setVisible(true)
      elem[!active].setVisible(false)
      ndx++

    return ## end displayVal

##-------------------------------------------------------------------
  resetVal: (val) ->
    val = val || @initValue
    @value = if (val < @initValue) then val else @initValue
    @displayVal()

    return ## end resetVal

##-------------------------------------------------------------------
  setVal: (val) ->
    @resetVal(val)

    return ## end setVal

##-------------------------------------------------------------------
  getVal: () ->
    return @value ## end of getVal

##-------------------------------------------------------------------
  increasVal: () ->
    @initValue++
    @value++
    @assemble()
    @displayVal()

    return @value ## end addCount

##-------------------------------------------------------------------
  decreasVal: () ->
    if @value > 0
      @value--
      @displayVal()

    return @value ## end dropLifes

)
