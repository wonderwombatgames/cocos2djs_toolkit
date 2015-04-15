###
 * GameWorld class: holds game static objects
###

## wonder wombat namespace
ww = ww || {}

##======== GameWorld
ww.GameWorldClass = cc.Class.extend(
  space: null
  winsize: null
  components: null
  gravity: cp.v(0,0)

##-------------------------------------------------------------------
  ctor: (config) ->
    @config = config
    @init()

    return ## end ctor

##-------------------------------------------------------------------
  init: () ->
    @winsize = cc.director.getWinSize()
    @space = new cp.Space()  ## create physical space

    if (@config?)
      @parseConfig()

    return true  ## end of init

##-------------------------------------------------------------------
  parseConfig: () -> 
    ## update gravity
    if (@config.hasOwnProperty("gravity"))
      @gravity = cp.v(@config.gravity[0]*@winsize.width, @config.gravity[1]*@winsize.height)
      # cc.log("GameWorldClass::parseConfig - gravity.y: " + @config.gravity[1]*@winsize.height)

    if (@config.hasOwnProperty("shapes"))
      ## process segments
      if (@config.shapes.segments?)
        for i in @config.shapes.segments
          @createSegment(i.point1, i.point2, i.elasticity, i.tag)

      ## process circles
      if (@config.shapes.circles?)
        for i in @config.shapes.circles
          @createCircle(i.radius, i.offset, i.elasticity, i.tag)

      ## process polygons
      if (@config.shapes.polygons?)
        for i in @config.shapes.polygons
          @createPolygon(i.vertices, i.offset, i.elasticity, i.tag)

    return  ## end parseConfig

##-------------------------------------------------------------------
  createSegment: (point1, point2, elasticity, tag) ->
    ## scale to window size
    p1 = cp.v(point1[0]*@winsize.width, point1[1]*@winsize.height)
    p2 = cp.v(point2[0]*@winsize.width, point2[1]*@winsize.height)

    # cc.log("GameWorldClass::createSegment - p1.x: " + point1[0]*@winsize.width + 
    #        " - p1.y: " + point1[1]*@winsize.height +
    #        " - p2.x: " + point2[0]*@winsize.width +
    #        " - p2.y: " + point2[1]*@winsize.height )

    ## create
    segment = new cp.SegmentShape(@space.staticBody, p1, p2, 0)

    ## set parameters
    segment.setElasticity(elasticity)
    segment.setCollisionType(tag)
    @space.addStaticShape(segment)

    return  ## end createSegment

##-------------------------------------------------------------------
  createCircle: (radius, offset, elasticity, tag) ->
    ## scale to window size
    diag = Math.sqrt(@winsize.width*@winsize.width + @winsize.height*@winsize.height)
    r = radius * diag
    c = cp.v(offset[0]*@winsize.width, offset[1]*@winsize.height)

    # cc.log("GameWorldClass::createCirlce" + 
    #        " - diag: " +diag +
    #        " - r: " + r + 
    #        " - c.x: " + offset[0]*@winsize.width +
    #        " - c.y: " + offset[1]*@winsize.height )

    ## create
    circle = new cp.CircleShape(@space.staticBody, r, c)

    ## set parameters
    circle.setElasticity(elasticity)
    circle.setCollisionType(tag)
    @space.addStaticShape(circle)

    return  ## end createSegment

##-------------------------------------------------------------------
  createPolygon: (vertices, offset, elasticity, tag) ->
    ## scale to window size
    c = cp.v(offset[0]*@winsize.width, offset[1]*@winsize.height)

    v = []
    n = 0
    for i in vertices
      axis = (n % 2) && @winsize.width || @winsize.height
      n++
      v.push(i*axis)

    # cc.log("GameWorldClass::createPolygon " +
    #        "- c.x: " + offset[0]*@winsize.width +
    #        "- c.y: " + offset[1]*@winsize.height )

    ## create
    polygon = new cp.PolyShape(@space.staticBody, v, c)

    ## set parameters
    polygon.setElasticity(elasticity)
    polygon.setCollisionType(tag)
    @space.addStaticShape(polygon)

    return  ## end createSegment

)
