cc.chartboostx =
  ftable: {}
  connectionId: 0

  subscribe: (callerName, location, callback, sender) ->
    @connectionId++
    key = callerName + "_" + location
    connection = key + "-" + @connectionId
    @ftable[key] =  @ftable[key] || {}
    @ftable[key][connection] = {"cb": callback, "obj": sender}

    return connection ## end subscrube

  unsubscribe: (conn) ->
    cc.log(@ftable)
    keys = conn.split("-")
    delete @ftable[keys[0]][conn]

    return ## end unsubscribe

  dispatch: (callerName, location) ->
    key = callerName+"_"+location
      
    if(@ftable.hasOwnProperty(key))
      for connId in @ftable[key]
        if (@ftable[key].hasOwnProperty(connId))
          cc.log(connId)
          cc.log(@ftable[key])
          cc.log(@ftable[key][connId])
          callback = @ftable[key][connId]["cb"]
          sender = @ftable[key][connId]["obj"]
          callback(connId, sender)
  
    return ## end dispatch

  trigger:  (callerName, location) ->
    if (cc.sys.isNative) 
      if (cc.sys.OS_ANDROID)
        jsb.reflection.callStaticMethod("com/wonderwombat/ChartboostX/ChartboostXBridge",
                                        callerName,
                                        "(Ljava/lang/String)V",
                                        location)
      #else if (cc.sys.OS_IOS)

    return ## end trigger
