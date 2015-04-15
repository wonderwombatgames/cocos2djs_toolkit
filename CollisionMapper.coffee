## wonder wombat namespace
ww = ww || {}

##======== manages colisions - each entity has one
ww.CollisionMapper = cc.Class.extend(
##-------------------------------------------------------------------
  ctor: () ->
    @init()

    return  ## end ctor

##-------------------------------------------------------------------
  init: () ->
    @collisionFP = [null,
                    null,
                    null,
                    null]

    return true ## end init

##-------------------------------------------------------------------
  remap: (fp, index) ->
    @collisionFP[index] = fp

    return  ## end remap

##-------------------------------------------------------------------
  setup: (tag1, tag2, space, collisionCBs) ->
    if (typeof(collisionCBs) == "object")
      if (collisionCBs.hasOwnProperty(length))
        ## if collisionCBs is an array
        range = collisionCBs.length
        for i in range
          if (typeof(collisionCBs[i]) == "function")
            ## and ith element is function
            @collisionFP[i] = collisionCBs[i]
    else 
      ## otherwise it might be a single function
      if typeof(collisionCBs) == "function"
        @collisionFP[0] = collisionCBs

    self = this
    @space = space
    space.addCollisionHandler(tag1, 
                              tag2,
                              self.collisionBegin.bind(self),
                              self.collisionPreSolve.bind(self),
                              self.collisionPostSolve.bind(self),
                              self.collisionSeparate.bind(self))

    return  ## end setup


##-------------------------------------------------------------------
  reset: (tag1, tag2) ->
    @space.removeCollisionHandler(tag1, tag2)

    return  ## end reset

##-------------------------------------------------------------------
  collisionBegin: (arbiter, space) ->

    if (@collisionFP[0]?)
      return @collisionFP[0](arbiter, space)
    else
      return false  ## end collisionBegin

##-------------------------------------------------------------------
  collisionPreSolve: (arbiter, space) ->

    if (@collisionFP[1]?)
      return @collisionFP[1](arbiter, space)
    else
      return false  ## end collisionPreSolve

##-------------------------------------------------------------------
  collisionPostSolve: (arbiter, space) ->
  
    if (@collisionFP[2]?)
      return @collisionFP[2](arbiter, space)
    else
      return false  ## end collisionPostSolve

##-------------------------------------------------------------------
  collisionSeparate: (arbiter, space) ->

    if (@collisionFP[3]?)
      return @collisionFP[3](arbiter, space)
    else
      return false  ## end collisionSeparate

)
