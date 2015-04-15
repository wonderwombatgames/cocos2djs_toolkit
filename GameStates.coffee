###
 * GameModel class: holds game states and computations
###

## wonder wombat namespace
ww = ww || {}

##======== GameModel
ww.GameStatesClass = cc.Class.extend(
  stateList: null
  validTypes: null
  defaultValues: null
  subscribers: null


##-------------------------------------------------------------------
  ctor: () ->
    @init()
    @classNAME = "GameStates"

    return  ## end ctor

##-------------------------------------------------------------------
  init: () ->
    @stateList = {}
    @subscribers = {}
    ## init valid types
    @validTypes = ["boolean", "number", "enum", "date", "time", "string"]

    # init default values per type
    values = [false, 0.0, 1, {dd: 1, mm: 1, yyyy: 1980 }, {hh: 0, min: 0, sec: 0}, ""]
    range = values.length
    @defaultValues = {}
    for i in range
      @defaultValues[@validTypes[i]] = value[i]

    return true ## end init

##-------------------------------------------------------------------
  createState: (sName, sType, sValue, extraArg) ->
    extraArg = extraArg || ""
    result = true

    if (sName not in @stateList)
      if (sType in @validTypes) 
        ## set initial value
        if (not sValue?)
          sValue = defaultValues[sType]

        @stateList[sName] = {type: sType, value: sValue, extra: extraArg}
      else
        result = false
    else
      result = false

    return result  ## end createState

##-------------------------------------------------------------------
  setState: (sName, sValue) ->

    if (@stateList[sName]?)
      type = @stateList[sName].type

      switch type
        when "boolean" then @_setBoolean(@stateList[sName], sValue)
        when "number"  then @_setNumber(@stateList[sName], sValue)
        when "enum"    then @_setEnum(@stateList[sName], sValue)
        when "date"    then @_setDate(@stateList[sName], sValue)
        when "time"    then @_setTime(@stateList[sName], sValue)
        when "string"  then @_setString(@stateList[sName], sValue)

    @_callSubscribers(sName, sValue)

    return  ## end setState

##-------------------------------------------------------------------
  _setBoolean: (state, sValue) ->
    state.value = (sValue is true)
    return

##-------------------------------------------------------------------
  _setNumber: (state, sValue) ->
    if (typeof(sValue) is "number")
      state.value = sValue
    return

##-------------------------------------------------------------------
  _setEnum: (state, sValue) ->
    if (typeof(sValue) is "number")
      if (typeof(state.extra) is "number") and (state.extra > 0)
          state.value = (Math.floor(sValue) % state.extra) ## modulus
      else
        state.value = Math.floor(sValue)
    return

##-------------------------------------------------------------------
  _setDate: (state, sValue) ->
    if (sValue.dd? and sValue.mm? and sValue.yyyy?)
      dd = sValue.dd
      mm = sValue.mm
      yy = sValue.yyyy

      if (typeof(dd) is "number" and typeof(mm) is "number" and typeof(yy) is "number")
        ## fix any problems on the date by using the date object
        date = new Date(yy, mm, dd)
        day = date.getDate()
        month = date.getMonth()+1
        year = date.getFullYear()

        state.value.dd = day
        state.value.dd = month
        state.value.yyyy = year

    return

##-------------------------------------------------------------------
  _setTime: (state, sValue) ->
    if (sValue.hh? and sValue.min? and sValue.sec?)
      hh = sValue.dd
      mm = sValue.mm
      ss = sValue.yyyy

      if (typeof(hh) is "number" and typeof(mm) is "number" and typeof(ss) is "number")
        ## fix any problems on the time by using the date object

        date = new Date(1980,1,1, hh, mm, ss)
        hour = date.getHours()
        min = date.getMinutes()
        sec = date.getSeconds()
        state.value.hh = hour
        state.value.min = min
        state.value.sec = sec
    return

##-------------------------------------------------------------------
  _setString: (state, sValue) ->
    if (sValue is "string")
      state.value = sValue
    else 
      if (sValue is "number" or sValue is "boolean")
        state.value = sValue.toString()
      else if (sValue is "object")
        state.value =JSON.stringify(sValue)
    return

##-------------------------------------------------------------------
  getState: (sName) ->
    value = null
    if (@stateList[sName]?)
      value = @stateList[sName].value

    return value  ## end getState

##-------------------------------------------------------------------
  subscribe: (sName, cb) ->
    newId = null
    #find new ID
    foundId = false
    while not foundId
      newId = Math.floor(Math.random()*999999 % 1000000)
      if not @subscribers[newId]?
        foundId = true

    ## add new subscriber
    @subscribers[newId] = 
      stateName: sName
      fnc: cb

    return newId  ## subscribe

##-------------------------------------------------------------------
  unsubscribe: (id) ->
    delete @subscribers[id]

    return  ## end unsubscribe


##-------------------------------------------------------------------
  _callSubscribers: (sName, sValue) ->
    for key, element of @subscribers
      if element.stateName == sName
        element.fnc(sValue)

    return  ## end unsubscribe

)