###
 * Entity class: holds sprite and physics
###

## wonder wombat namespace
ww = ww || {}

##======== Entity with square body
ww.EntitySquareClass = cc.Class.extend(
  space: null
  sprite: null
  shape: null
  body: null
  isActive: false

##-------------------------------------------------------------------
  ##  Constructor
  ##    @param {string}
  ##    @param {cp.Space *}
  ##    @param {cc.p}
  ##    @param {mass value > 0.0}
  ##    @param {elasticity value 0.0..1.0}
  ctor: (resource, space, pos, mass, elast) ->
    @entityTag = 999
    @opacity = 255 ## opacity: defaults to 100%
    @scale = 1 ## scale  : defaults to 1
    @init(resource, space, pos, mass, elast)

    return ## end CTOR

##-------------------------------------------------------------------
  init: (resource, space, pos, mass, elast) ->
    @space = space

    ## create sprite components
    spriteComponents = @createSprite(resource, pos, mass)

    ##spriteComponents.setRotation(90)
    @sprite = spriteComponents.s
    @sprite.retain()
    @body   = spriteComponents.b
    @shape  = spriteComponents.x

    ## set elasticity to allow bouncing
    @shape.setElasticity(elast)

    ## set collision tag
    @shape.setCollisionType(@entityTag)

    return true ## end of init

##-------------------------------------------------------------------
  tick: (dt) ->
    ## empty implementation as to be specialized
    return  ## end tick

##-------------------------------------------------------------------
  setActive: (toggle) ->
    @isActive = toggle
    @sprite.setVisible(toggle)

    return  ## end setActive

##-------------------------------------------------------------------
  createSprite: (resource, pos, mass) ->
    return ww.spriteFactory.createPhysicsSquareSprite(resource, 
                                                      @space, 
                                                      pos, 
                                                      mass,
                                                      @opacity,
                                                      @scale)

##-------------------------------------------------------------------
  getSprite: () ->
    return @sprite ## end of getSprite

##-------------------------------------------------------------------
  getShape: () ->
    return @shape ## end of getShape

##-------------------------------------------------------------------
  getBody: () ->
    return @body ## end of get Body

##-------------------------------------------------------------------
  removeFromParent: () ->
    @space.removeStaticShape(@shape)
    @shape = null
    @body.removeFromParent()
    @body = null
    @sprite.removeFromParent()
    @sprite = null
    return ## end of removeFromParent

##-------------------------------------------------------------------
  setTag: (tag) ->
    @entityTag = tag

    return ## end of setTag

##-------------------------------------------------------------------
  setPosition: (pos) ->
    contentSize = @sprite.getContentSize()
    @body.setPos(cc.p(pos.x + contentSize.width / 2, pos.y + contentSize.height / 2))

    return ## end of setPosition

)


##======== Entity with circle body
ww.EntityCircleClass = ww.EntitySquareClass.extend(
##-------------------------------------------------------------------
  ##  Constructor
  ##    @param {string}
  ##    @param {cp.Space *}
  ##    @param {cc.p}
  ##    @param {mass value > 0.0}
  ##    @param {elasticity value 0.0..1.0}
  ctor: (resource, space, pos, mass, elast, centroid) ->
    @entityTag = 998
    @opacity = 255 ## opacity: defaults to 100%
    @scale = 1 ## scale  : defaults to 1
    @centroid = centroid || cp.v(0,0)
    @init(resource, space, pos, mass, elast)

    return ## end CTOR

##-------------------------------------------------------------------
  createSprite: (resource, pos, mass) ->
    return ww.spriteFactory.createPhysicsCircleSprite(resource, 
                                                      @space, 
                                                      pos, 
                                                      mass,
                                                      @centroid,
                                                      @opacity,
                                                      @scale)
)


##======== Entity with circle body
ww.EntityPolyClass = ww.EntitySquareClass.extend(
##-------------------------------------------------------------------
  ##  Constructor
  ##    @param {string}
  ##    @param {cp.Space *}
  ##    @param {cc.p}
  ##    @param {mass value > 0.0}
  ##    @param {elasticity value 0.0..1.0}
  ctor: (resource, space, pos, mass, elast, vertices, centroid) ->
    @entityTag = 997
    @opacity = 255 ## opacity: defaults to 100%
    @scale = 1 ## scale  : defaults to 1
    @vertices = vertices || cp.v(0,0)
    @centroid = centroid || [-1,-1,1,-1,1,1,1,-1]
    @init(resource, space, pos, mass, elast)

    return ## end CTOR

##-------------------------------------------------------------------
  createSprite: (resource, pos, mass) ->
    return ww.spriteFactory.createPhysicsPolySprite(resource, 
                                                      @space, 
                                                      pos, 
                                                      mass,
                                                      @vertices,
                                                      @centroid
                                                      @opacity,
                                                      @scale)
)