Function Main(args as Dynamic) as Void
	if (args.mediaType="video") AND (args.contentID="1")
		print "Entered Content id is--------->>>>>"args.contentID
		screen = CreateObject("roSGScreen")
		port = CreateObject("roMessagePort")
		screen.SetMessagePort(port)
		m.scene = screen.CreateScene("DeepLinkScene")
		m.scene.movieID=args.contentID
		screen.Show()
		while(true)
			msg = wait(0, port)
			msgType = type(msg)
			if msgType = "roSGScreenEvent"
				if msg.isScreenClosed() then return
			end if
		end while
	else
		showChannelSGScreen()        
	end if
end Function

sub showChannelSGScreen()
'DeleteFavorite()
    m.screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    m.screen.setMessagePort(m.port)	
	'm.global = m.screen.getGlobalNode()

	'm.global.id = "GlobalNode"
	'm.global.addFields({token:token,username:username})	
    scene = m.screen.CreateScene("MainScene")
    m.screen.show()
     m.msgPort = CreateObject("roMessagePort")
    while true
    'Create roInput in each loop so that every roInputEvent would be received
    m.input = CreateObject("roInput")
    m.input.SetMessagePort(m.msgPort)

   '' print "Waiting for input..."
    msg = wait(1000, m.msgPort)
    'print"hello"type(msg)
    if type(msg) = "roInputEvent"
      if msg.isInput()
        m.input = msg.GetInfo()
        print "Received input: "; FormatJSON(m.input)
      end if
    end if
  end while
end sub


function scale(fromVal = 1 as Integer) as Dynamic
	dInfo = CreateObject("roDeviceInfo")
	mode = getDisplayMode()
	if mode = "FHD" then
		return (fromVal)
	else if mode = "HD" then 'FHD->HD:720/1080'
		return (fromVal)
	else if mode = "SD" then 'FHD->SD:480/1080'
		return (fromVal * 0.44444)
	end if
end function

Function SetResumeTime(streamid As String,value As String) As Void
    sec = CreateObject("roRegistrySection","holyPlaces")
    print"the stream id is==>"streamid
    print"the value is ===>"value
    sec.Write(streamid,value)
    sec.Flush()
End Function

Function GetResumeTime(id As String) As Dynamic
    sec = CreateObject("roRegistrySection","holyPlaces")
    if sec.Exists(id)
        return sec.Read(id)
    endif
    return invalid
End Function

Function DeleteResumeTime(id As String) As Dynamic
     secToken = CreateObject("roRegistrySection", "holyPlaces")
     if secToken.Exists(id)
         return secToken.Delete(id)
     endif
     return invalid
End Function

Function SetFavorite(value As String) As Void
    sec = CreateObject("roRegistrySection","holyPlaces")
    print"the value is ===>"value
    sec.Write("favorite",value)
    sec.Flush()
End Function

Function GetFavorite() As Dynamic
    sec = CreateObject("roRegistrySection","holyPlaces")
    if sec.Exists("favorite")
        return sec.Read("favorite")
    endif
    return invalid
End Function

Function DeleteFavorite() As Dynamic
     secToken = CreateObject("roRegistrySection", "holyPlaces")
     if secToken.Exists("favorite")
         return secToken.Delete("favorite")
     endif
     return invalid
End Function

function getDisplayMode() as String
	gaa = getGlobalAA()
	if gaa.displayMode = Invalid then
	    deviceinfo = CreateObject("roDeviceInfo")
	    displaySize = deviceinfo.getDisplaySize()
	    if displaySize.h = 1080
	        gaa.displayMode = "FHD"
	    else if displaySize.h = 720
	        gaa.displayMode = "HD"
	    else if displaySize.h = 480
	        gaa.displayMode = "SD"
	    end if
	    return gaa.displayMode
	else
		return gaa.displayMode
	end if
end function


