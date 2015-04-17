###
 * sprite factory object
###

## wonder wombat namespa
ww = ww || {}

## factory for most common sprite types
ww.spriteFactory = {

##-------------------------------------------------------------------
  ## Create square sprite w/ physics
  createStaticSquareSprite: (image, space, pos, mass, opacity, scale) ->
    opacity = opacity || 255
    scale = scale || 1

    ## 1. create PhysicsSprite with a sprite frame image
    sprite = @createPhysicsSprite(image, opacity, scale)

    contentSize = sprite.getContentSize()
    contentSize.width = contentSize.width * scale
    contentSize.length = contentSize.length * scale

    ## 2. init the physics body
    body = new cp.StaticBody();

    ## 6. create the shape for the body
    shape = new cp.BoxShape(body,
                            contentSize.width,
                            contentSize.height)


    return @presetPhysicsSprite(space, pos, contentSize, shape, body, sprite) ## end createPhysicsSquareSprite

##-------------------------------------------------------------------
  ## Create circle sprite w/ physics
  createStaticCircleSprite: (image, space, pos, mass, centroid, opacity, scale) ->
    opacity = opacity || 255
    scale = scale || 1
    centroid = centroid || cp.v(0,0)

    ## 1. create PhysicsSprite with a sprite frame image
    sprite = @createPhysicsSprite(image, opacity, scale)

    contentSize = sprite.getContentSize()
    contentSize.width = contentSize.width * scale
    contentSize.length = contentSize.length * scale

    ## 2. init the physics body
    body = new cp.StaticBody();

    ## 6. create the shape for the body
    shape = new cp.CircleShape(body,
                               contentSize.width/2,
                               centroid)

    return @presetPhysicsSprite(space, pos, contentSize, shape, body, sprite) ## end createPhysicsCircleSprite

##-------------------------------------------------------------------
  ## Create polygon sprite w/ physics
  createStaticPolySprite: (image, space, pos, mass, vertices, centroid, opacity, scale) ->
    opacity = opacity || 255
    scale = scale || 1
    centroid = centroid || cp.v(0,0)

    ## 1. create PhysicsSprite with a sprite frame image
    sprite = @createPhysicsSprite(image, opacity, scale)

    contentSize = sprite.getContentSize()
    contentSize.width = contentSize.width * scale
    contentSize.length = contentSize.length * scale

    ## 2. init the physics body
    body = new cp.StaticBody();

    ## 6. create the shape for the body
    shape = new cp.PolyShape(body,
                             vertices,
                             centroid)

    return @presetPhysicsSprite(space, pos, contentSize, shape, body, sprite) ## end createPhysicsCircleSprite


##-------------------------------------------------------------------
  ## Create square sprite w/ physics
  createPhysicsSquareSprite: (image, space, pos, mass, opacity, scale) ->
    opacity = opacity || 255
    scale = scale || 1

    ## 1. create PhysicsSprite with a sprite frame image
    sprite = @createPhysicsSprite(image, opacity, scale)

    contentSize = sprite.getContentSize()
    contentSize.width = contentSize.width * scale
    contentSize.length = contentSize.length * scale

    ## 2. init the physics body
    inertiaMomentB = cp.momentForBox(mass,
                                     contentSize.width,
                                     contentSize.height)
    body = new cp.Body(mass, inertiaMomentB)

    ## 6. create the shape for the body
    shape = new cp.BoxShape(body,
                            contentSize.width,
                            contentSize.height)


    return @presetPhysicsSprite(space, pos, contentSize, shape, body, sprite) ## end createPhysicsSquareSprite

##-------------------------------------------------------------------
  ## Create circle sprite w/ physics
  createPhysicsCircleSprite: (image, space, pos, mass, centroid, opacity, scale) ->
    opacity = opacity || 255
    scale = scale || 1
    centroid = centroid || cp.v(0,0)

    ## 1. create PhysicsSprite with a sprite frame image
    sprite = @createPhysicsSprite(image, opacity, scale)

    contentSize = sprite.getContentSize()
    contentSize.width = contentSize.width * scale
    contentSize.length = contentSize.length * scale

    ## 2. init the physics body
    inertiaMomentC = cp.momentForCircle(mass,
                                        contentSize.width / 2,
                                        contentSize.height / 2,
                                        centroid)
    body = new cp.Body(mass, inertiaMomentC)

    ## 6. create the shape for the body
    shape = new cp.CircleShape(body,
                               contentSize.width/2,
                               centroid)

    return @presetPhysicsSprite(space, pos, contentSize, shape, body, sprite) ## end createPhysicsCircleSprite

##-------------------------------------------------------------------
  ## Create polygon sprite w/ physics
  createPhysicsPolySprite: (image, space, pos, mass, vertices, centroid, opacity, scale) ->
    opacity = opacity || 255
    scale = scale || 1
    centroid = centroid || cp.v(0,0)

    ## 1. create PhysicsSprite with a sprite frame image
    sprite = @createPhysicsSprite(image, opacity, scale)

    contentSize = sprite.getContentSize()
    contentSize.width = contentSize.width * scale
    contentSize.length = contentSize.length * scale

    ## 2. init the physics body
    inertiaMomentP = cp.momentForPoly(mass,
                                      vertices,
                                      centroid)
    body = new cp.Body(mass, inertiaMomentP)

    ## 6. create the shape for the body
    shape = new cp.PolyShape(body,
                             vertices,
                             centroid)

    return @presetPhysicsSprite(space, pos, contentSize, shape, body, sprite) ## end createPhysicsCircleSprite

##-------------------------------------------------------------------
  presetPhysicsSprite: (space, pos, contentSize, shape, body, sprite) ->
    ## 3. set the position of the sprite
    body.setPos(cc.p(pos.x + contentSize.width/2,
                     pos.y + contentSize.height/2))

    ## 5. add the created body to space
    space.addBody(body)

    ## 7. add shape to space
    space.addShape(shape)

    ## 8. set body to the physic sprite
    sprite.setBody(body)

    ## 9. pack compnents into an object to return
    retObj = b: body, x: shape, s: sprite

    return retObj ## end presetPhysicsSprite

##-------------------------------------------------------------------
createPhysicsSprite: (image, opacity, scale) ->
    ## 1. create PhysicsSprite with a sprite frame image
    opacity = opacity || 255
    scale = scale || 1
    sprite = new cc.PhysicsSprite(image)
    sprite.retain()
    sprite.setScale(scale)
    sprite.setOpacity(opacity)

    return sprite ## end createPhysicsSprite

##-------------------------------------------------------------------
  createSimpleSprite: (image, pos, opacity, scale) ->
    opacity = opacity || 255
    scale = scale || 1
    sprite = new cc.Sprite(image)
    sprite.setPosition(pos)
    sprite.setScale(scale)
    sprite.setOpacity(opacity)
    
    return sprite ## end of addSprite

##-------------------------------------------------------------------
  createMenu: (menuItems, parent, pos) ->
    ## set menu font size as defined globaly
    cc.MenuItemFont.setFontSize(global.style.menuFontSize)

    ## create menu items with assigned event callbacks
    items = []
    for item in menuItems
        activeImg = new cc.Sprite(item.activeImg)
        acScale = item.actScale || 1
        activeImg.setScale(acScale)
        inactiveImg = new cc.Sprite(item.inactiveImg)
        inScale = item.inactScale || 1
        inactiveImg.setScale(inScale)
        items.push( new cc.MenuItemSprite(
            activeImg,   ## selected state image
            inactiveImg, ## noemal   state image
            item.callback,
            parent))

    ## create the buttons
    menu = new cc.Menu(items)
    menu.setPosition(pos)

    return menu ## end of createMenu

##-------------------------------------------------------------------
  createVertMenu: (menuItems, parent, pos, pad) ->
    menu = @createMenu(menuItems, parent, pos)
    menu.alignItemsVerticallyWithPadding(pad)

    return  menu ## end of createVertMenu

##-------------------------------------------------------------------
  createHorizMenu: (menuItems, parent, pos, pad) ->
    menu = @createMenu(menuItems, parent, pos)
    menu.alignItemsHorizontallyWithPadding(pad)

    return  menu ## end of createHorizMenu

##-------------------------------------------------------------------
  createLabelMenu: (menuItems, colors, pos) ->
    self = this

    ## create menu items with assigned event callbacks
    items = []
    for item in menuItems
      items.push(@createLabelItem(colors, 
                                  item.glyphCode,
                                  item.size, 
                                  item.trigger,
                                  item.node))

    ## create the buttons
    labelMenu = new cc.Menu(items)
    labelMenu.setPosition(pos)
    
    return labelMenu ## end createMenuBtn

##-------------------------------------------------------------------
  createLabelItem: (colors, glyphCode, size, trigger, node) ->
    self = this

    ## glyph icon
    glyphColor = colors.font || cc.color(213,101,44, 196) ## orange
    strokeColor = colors.stroke || cc.color(204,34,41, 196) ## dark orange
    shadowColor = colors.shadow || cc.color(0,0,0, 150) ## black
    glyphLabel = ww.spriteFactory.createGlyph(glyphCode, size, glyphColor, strokeColor, shadowColor)

    ## create label menu item
    labelItem = new cc.MenuItemLabel(glyphLabel, trigger, node)

    return labelItem ## end createMenuBtn

##-------------------------------------------------------------------
  createGlyph: (glyphCode, size, glyphColor, strokeColor, shadowColor) ->
    ## glyph icon
    glyphLabel = new cc.LabelTTF(String.fromCharCode(glyphCode), 
                                global.glyph.fontName, 
                                size)
    size = Math.floor(glyphLabel.getContentSize().width / 16)

    glyphLabel.setColor(glyphColor)
    glyphLabel.enableStroke(strokeColor, size)
    glyphLabel.enableShadow(shadowColor, cp.v(size, -size), 2*size)
    
    glyphLabel.retain()

    return glyphLabel  ## end createGlyph
}
