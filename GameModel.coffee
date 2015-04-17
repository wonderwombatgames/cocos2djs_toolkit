###
 * GameModel class: holds game states and computations
###

## wonder wombat namespace
ww = ww || {}

##======== GameModel
ww.GameModelClass = cc.Node.extend(
  winsize: null
  world: null
  entities: null
  states: null
  logic: null
  paused = true

##-------------------------------------------------------------------
  ctor: (worldCfg) ->
    @_super()
    @init(worldCfg)
    @classNAME = "GameModel"

    return ## end ctor

##-------------------------------------------------------------------
  init: (worldCfg) ->
    ## init local attributes
    @winsize = cc.director.getWinSize()

    ## config physics
    @world = new ww.GameWorldClass(worldCfg)

    ## new game states object
    @states = new ww.GameStatesClass()

    ## set empty entities object
    @entities = {}

    ## audio
    cc.audioEngine.setMusicVolume(0.5)
    cc.audioEngine.setEffectsVolume(0.5)

    return true ## end init

##-------------------------------------------------------------------
  setupLogic: (_gameLogic) ->

    @logic = _gameLogic
    @logic.init()

    return ## end setupLogic 

##-------------------------------------------------------------------
  resumeModel: () ->
    ## restart updating physics simulation
    @scheduleUpdate()

    ## audio
    cc.audioEngine.resumeMusic()

    cc.log("===resuming model")

    return ## end onEnter

##-------------------------------------------------------------------
  pauseModel: () ->
    ## stop updating physics simulation
    @unscheduleUpdate()
    cc.log("===pausing model")

    ## audio
    cc.audioEngine.stopAllEffects()
    cc.audioEngine.pauseMusic()

    return ## end onExit

##-------------------------------------------------------------------
  update: (dt) ->
    ## physiscs update
    @world.space.step(dt)

    ## call entitites ticks
    for id,entity of @entities 
      entity.tick(dt)

    return  ## end update

##-------------------------------------------------------------------
  registerEntity: (entity, id) ->
    @entities[id] = entity

    return ## end update

##-------------------------------------------------------------------
  unregisterEntity: (id) ->
    if @entities[id]?
      delete @entities[id]

    return ## end update

##-------------------------------------------------------------------
  getEntityByShape: (shape) ->
    ret = []
    for id,entity of @entities
      if entity.getShape?
        if shape == entity.getShape()
          ret.push(entity)

    return ret ## end getEntityByShape

##-------------------------------------------------------------------
  getEntityByBody: (body) ->
    ret = []
    for id,entity of @entities
      if entity.getBody?
        if body == entity.getBody()
          ret.push(entity)

    return ret ## end getEntityByShape

##-------------------------------------------------------------------
  getEntityBySprite: (sprite) ->
    ret = []
    for id,entity of @entities
      if entity.getSprite?
        if sprite == entity.getSprite()
          ret.push(entity)

    return ret ## end getEntityByShape

##-------------------------------------------------------------------
  getEntityByTag: (tag) ->
    ret = []
    for id,entity of @entities
      if entity.entityTag?
        if tag == entity.entityTag
          ret.push(entity)

    return ret ## end getEntityByTag

##-------------------------------------------------------------------
  getEntityById: (id) ->
    ## just one entity by id
    return @entities[id] ## end getEntityById

)