Sub init()
m.contentRetriever = m.global.contentRetriever 
m.top.backgroundURI=""
m.top.backgroundColor="#ffffff"


	
	m.videoPlayer=m.top.findNode("videoPlayer")
	m.videoPlayer.height=scale(720)
	m.videoPlayer.width=scale(1280)

	m.loadingIndicator=m.top.findNode("loadingIndicator")
	m.loadingIndicator.translation=[scale(568),scale(500)]
	
	m.detailInvisibleTimer=m.top.findNode("detailInvisibleTimer")

	m.detailPosterVideoPLayback=m.top.findNode("detailPosterVideoPLayback")
	m.opacityBGVideoPLayback=m.top.findNode("opacityBGVideoPLayback")
	m.detailTitleVideoPLaybackVideoPLayback=m.top.findNode("detailTitleVideoPLaybackVideoPLayback")
	m.detailDescriptionVideoPLaybackVideoPLayback=m.top.findNode("detailDescriptionVideoPLaybackVideoPLayback")
	m.videoPlayBackLoad=m.top.findNode("videoPlayBackLoad")
	m.detailTitleVideoPLaybackLoadIngNumber=m.top.findNode("detailTitleVideoPLaybackLoadIngNumber")

	m.videoPlayBackPlay=m.top.findNode("videoPlayBackPlay")
	m.detailTitleVideoPLaybackVideoPLay=m.top.findNode("detailTitleVideoPLaybackVideoPLay")
	m.videoPlayerUI=m.top.findNode("videoPlayerUI")
	m.play_pause_Icon=m.top.findNode("play_pause_Icon")
	m.R1Animation=m.top.findNode("R1Animation")
	m.R1A1translation=m.top.findNode("R1A1translation")
	m.playerInfoInvisibleTimer=m.top.findNode("playerInfoInvisibleTimer")
	m.seekTimerControler=m.top.findNode("seekTimerControler")
	m.playTimerControler=m.top.findNode("playTimerControler")
	m.speedXvalue=m.top.findNode("speedXvalue")
	m.showPlayerControl=false



	m.videoPlayer.observeField("state","onvideoStateChange")
	m.videoPlayer.observeField("bufferingStatus","loadingStatus")
	m.videoPlayer.observeField("duration","checkVideoDuration")

	m.detailInvisibleTimer.observeField("fire","playVideoAutomatic")
	m.playerInfoInvisibleTimer.observeField("fire","playerInfoInvisible")
	m.seekTimerControler.observeField("fire","seekTimerControlerFunc")
	m.playTimerControler.observeField("fire","playTimerControlerFunc")
	m.content=createObject("roSGNode","ContentNode")
	m.content.FHDPOSTERURL="http://holyplaces.woo.media/uploads/thumbs/covers/46ed1ca3f-1.jpg"
    m.content.HDPOSTERURL= "http://holyplaces.woo.media/uploads/thumbs/covers/46ed1ca3f-1.jpg"
    m.content.SHORTDESCRIPTIONLINE1= "26:00"
    m.content.SHORTDESCRIPTIONLINE2="One of the most original attraction in Akko is the Tunisian Or Torah Synagogue or &ldquo;Jariva;. This Synagogue is completely covered in mosaics, on the wall, floor and many stained-glass windows."
     m.content.STREAMFORMAT="hls"
     m.content.TITLE= "Or Thora Synagogue"
     m.content.URL= "https://player.vimeo.com/external/261038693.m3u8?s=fb9528ae60923a9242cd83f78b322c46c93d2f89"

	m.videoPlayer.content=m.content
	m.videoPlayer.control="play"
	m.videoPlayer.enableTrickPlay=false
	m.videoPlayer.enableUI=false
	 m.detailFocus=2
	 updateFocus()

End Sub

Sub loadingStatus()
'print"the buffering status is==>"m.videoPlayer.bufferingStatus
if m.videoPlayer.bufferingStatus<>invalid
	m.videoPlayBackLoad.visible=true
	m.detailPosterVideoPLayback.uri=m.content.fhdPosterURL
	m.detailTitleVideoPLaybackVideoPLayback.text=m.content.title
	m.detailDescriptionVideoPLaybackVideoPLayback.text=m.content.shortDescriptionLine2
	m.detailTitleVideoPLaybackLoadIngNumber.text=m.videoPlayer.bufferingStatus.percentage.toStr()+"%"
	m.loadingIndicator.control="start"
else
	m.videoPlayBackLoad.visible=false
	m.loadingIndicator.control="stop"
end if
ENd sub


Sub checkVideoDuration()
m.theValueOfX=0
m.theValueOfY=0

'print"the duration is==>"m.videoPlayer.duration
m.totalDurationLeft=m.videoPlayer.duration
print"the type is==>"type(m.totalDurationLeft)
m.videoPlayerUI.totalVideoDuration=m.totalDurationLeft
m.seekDuration=0
hours=m.totalDurationLeft\60
minutes=m.totalDurationLeft MOD 60
'print"the duration is==>"hours.toStr()+":"minutes.toStr()
m.videoPlayerUI.timeCountAText=hours.toStr()+":"+minutes.toStr()
m.videoPlayerUI.timeCountBText=m.seekDuration.toStr()+"0:00"

End sub

SUb showPlayerControl(value as boolean)
	if m.showPlayerControl=false
		m.R1A1translation.keyValue=[[0,720],[0,0]]

		m.showPlayerControl=true
	else
		m.R1A1translation.keyValue=[[0,0],[0,720]]

		m.showPlayerControl=false
	end if
m.R1Animation.control="start"
End sub

Sub playerInfoInvisible()
	'm.timerValue2+=1
	'if m.timerValue2=3
		m.playerInfoInvisibleTimer.control="stop"
		showPlayerControl(false)
	'end if

End sub


sub updateFocus()
	if m.detailFocus=0
		m.onpress.setFocus(true)
	else if m.detailFocus=1
		m.detailInvisibleTimer.control="stop"
		m.timerValue=0
		m.contentList_1.setFocus(true)
	else if m.detailFocus=2
		m.videoPlayer.setFocus(true)
	end if

end sub




Function onKeyEvent(key as String, press as Boolean) as Boolean
	handled = false

	if press 
	 if key="back"
	 	
	  else if key="down"
	  		if m.detailFocus=0 and m.detailScreen.visible=true
	  			m.detailFocus=1
	  			updateFocus()
	  			handled=true
	  		end if
	  else if key="up"
	  	print"up"
	  		if m.detailFocus=1 and m.detailScreen.visible=true
	  			m.detailFocus=0
	  			updateFocus()
	  			handled=true
	  		end if
	  else if key="play"
	  	if m.videoPlayer.visible=true and m.videoPlayer.bufferingStatus=invalid
	  		if m.playValue=0
	  			m.playValue=1	  			
	  			m.playerInfoInvisibleTimer.control="stop"
	  			if m.showPlayerControl=false
	  				showPlayerControl(true)
	  			end if
	  			m.play_pause_Icon.uri="pkg://images/play-button.png"
	  			m.videoPlayer.control="pause"
	  		else if m.playValue=1
	  			m.playValue=0
	  			'showPlayerControl(false)
	  			
	  			if m.seekInitiatedffrwd=true OR m.seekInitiatedrwnd=true
	  				m.playTimer=0
	  				m.seekTimerControler.control="stop"
	  				'print"m.seekDuration=>"m.seekDuration
	  				showPlayerControl(false)
	  				'm.videoPlayer.content=m.detailContentData					
					m.videoPlayer.seek=m.seekDuration
					m.videoPlayer.control="resume"
	  			else
	  				m.playerInfoInvisibleTimer.control="start"
	  				m.play_pause_Icon.uri="pkg://images/pause.png"
	  				m.videoPlayer.control="resume"
	  			endif
	  		end if
	  		handled=true
	  	end if
	  else if key="fastforward"
  	 	if m.videoPlayer.visible=true and m.videoPlayer.bufferingStatus=invalid
  	 		if (m.theValueOfX=0 OR m.theValueOfX>0)  AND m.theValueOfX<5
  	 			m.seekTimerControler.control="start"
  	 			m.seekInitiatedffrwd=true
  	 			m.seekInitiatedrwnd=false
  	 			m.theValueOfY=0
	  	 		m.theValueOfX+=1
	  	 		m.speedXvalue.text=m.theValueOfX.toStr()+"X"
  	 			'print"m.theValueOfX==>"m.theValueOfX

				m.totalDurationLeft=m.totalDurationLeft-(m.theValueOfX*5)
				m.seekDuration+=(m.theValueOfX*5)
				hours=m.totalDurationLeft\60
				minutes=m.totalDurationLeft MOD 60
				'print"the duration is==>"hours.toStr()+":"minutes.toStr()
				hoursSeek=m.seekDuration\60
				minutesSeek=m.seekDuration MOD 60
				'print"the duration is==>"hoursSeek.toStr()+":"minutesSeek.toStr()
				m.videoPlayerUI.timeCountAText=hours.toStr()+":"+minutes.toStr()
				m.videoPlayerUI.timeCountBText=hoursSeek.toStr()+":"+minutesSeek.toStr()
			end if	
  	 		m.playValue=1  
  	 		m.playerInfoInvisibleTimer.control="stop"
  			if m.showPlayerControl=false
  				showPlayerControl(true)
  			end if
  			m.play_pause_Icon.uri="pkg://images/play-button.png"		
	  		m.videoPlayer.control="pause"	  		
	  		handled=true
	  	end if
	  else if key="rewind"
	  	 	if m.videoPlayer.visible=true and m.videoPlayer.bufferingStatus=invalid
		  	 	if (m.theValueOfY=0 OR m.theValueOfY>0)  AND m.theValueOfY<5 AND m.seekDuration>0
		  	 		m.seekTimerControler.control="start"
		  	 		m.theValueOfX=0
		  	 		m.seekInitiatedrwnd=true
		  	 		m.seekInitiatedffrwd=false
			  	 	m.theValueOfY+=1
			  	 	m.speedXvalue.text=m.theValueOfY.toStr()+"X"
					m.totalDurationLeft=m.totalDurationLeft+(m.theValueOfY*5)
					m.seekDuration-=(m.theValueOfY*5)
			  	 	'print"m.theValueOfY==>"m.theValueOfY

					hours=m.totalDurationLeft\60
					minutes=m.totalDurationLeft MOD 60
					'print"the duration is==>"hours.toStr()+":"minutes.toStr()
					hoursSeek=m.seekDuration\60
					minutesSeek=m.seekDuration MOD 60
					'print"the duration is==>"hoursSeek.toStr()+":"minutesSeek.toStr()
					m.videoPlayerUI.timeCountAText=hours.toStr()+":"+minutes.toStr()
					m.videoPlayerUI.timeCountBText=hoursSeek.toStr()+":"+minutesSeek.toStr()	
				end if
		  		m.playValue=1	
		  		m.playerInfoInvisibleTimer.control="stop"
	  			if m.showPlayerControl=false
	  				showPlayerControl(true)
	  			end if
	  			m.play_pause_Icon.uri="pkg://images/play-button.png"  		
		  		m.videoPlayer.control="pause"	  		
		  		handled=true
		  	endif
	   else if key="right"
	   		if m.videoPlayer.visible=true and m.videoPlayer.bufferingStatus=invalid
	   			
	  	 		if (m.theValueOfX=0 OR m.theValueOfX>0)  AND m.theValueOfX<1
	  	 			m.seekTimerControler.control="start"
	  	 			m.seekInitiatedffrwd=true
	  	 			m.seekInitiatedrwnd=false
	  	 			m.theValueOfY=0
		  	 		m.theValueOfX+=1
		  	 		m.speedXvalue.text=m.theValueOfX.toStr()+"X"
	  	 			'print"m.theValueOfX==>"m.theValueOfX

					m.totalDurationLeft=m.totalDurationLeft-(m.theValueOfX*5)
					m.seekDuration+=(m.theValueOfX*5)
					hours=m.totalDurationLeft\60
					minutes=m.totalDurationLeft MOD 60
					'print"the duration is==>"hours.toStr()+":"minutes.toStr()
					hoursSeek=m.seekDuration\60
					minutesSeek=m.seekDuration MOD 60
					'print"the duration is==>"hoursSeek.toStr()+":"minutesSeek.toStr()
					m.videoPlayerUI.timeCountAText=hours.toStr()+":"+minutes.toStr()
					m.videoPlayerUI.timeCountBText=hoursSeek.toStr()+":"+minutesSeek.toStr()
				end if	
	  	 		m.playValue=1  
	  	 		m.playerInfoInvisibleTimer.control="stop"
	  			if m.showPlayerControl=false
	  				showPlayerControl(true)
	  			end if
	  			m.play_pause_Icon.uri="pkg://images/play-button.png"		
		  		m.videoPlayer.control="pause"	  		
		  		handled=true
		  	end if
		else if key="left"
		 	if m.videoPlayer.visible=true and m.videoPlayer.bufferingStatus=invalid
		  	 	if (m.theValueOfY=0 OR m.theValueOfY>0)  AND m.theValueOfY<1 AND m.seekDuration>0
		  	 		m.seekTimerControler.control="start"
		  	 		m.theValueOfX=0
		  	 		m.seekInitiatedrwnd=true
		  	 		m.seekInitiatedffrwd=false
			  	 	m.theValueOfY+=1
			  	 	m.speedXvalue.text=m.theValueOfY.toStr()+"X"
					m.totalDurationLeft=m.totalDurationLeft+(m.theValueOfY*5)
					m.seekDuration-=(m.theValueOfY*5)
			  	 	'print"m.theValueOfY==>"m.theValueOfY

					hours=m.totalDurationLeft\60
					minutes=m.totalDurationLeft MOD 60
					'print"the duration is==>"hours.toStr()+":"minutes.toStr()
					hoursSeek=m.seekDuration\60
					minutesSeek=m.seekDuration MOD 60
					'print"the duration is==>"hoursSeek.toStr()+":"minutesSeek.toStr()
					m.videoPlayerUI.timeCountAText=hours.toStr()+":"+minutes.toStr()
					m.videoPlayerUI.timeCountBText=hoursSeek.toStr()+":"+minutesSeek.toStr()	
				end if
		  		m.playValue=1	
		  		m.playerInfoInvisibleTimer.control="stop"
	  			if m.showPlayerControl=false
	  				showPlayerControl(true)
	  			end if
	  			m.play_pause_Icon.uri="pkg://images/play-button.png"  		
		  		m.videoPlayer.control="pause"	  		
		  		handled=true
	  		end if
	  	end if


	end if

	return handled
End Function


SUb playTimerControlerFunc()

m.totalDurationLeft-=1

'print"m.totalDurationLeft==>"m.totalDurationLeft
m.seekDuration+=1
m.videoPlayerUI.SeekPathMeasure=m.seekDuration
hours=m.totalDurationLeft\60
minutes=m.totalDurationLeft MOD 60
'print"the duration is==>"hours.toStr()+":"minutes.toStr()
hoursSeek=m.seekDuration\60
minutesSeek=m.seekDuration MOD 60
'print"the duration is==>"hoursSeek.toStr()+":"minutesSeek.toStr()
m.videoPlayerUI.timeCountAText=hours.toStr()+":"+minutes.toStr()
m.videoPlayerUI.timeCountBText=hoursSeek.toStr()+":"+minutesSeek.toStr()
End Sub 


Sub onvideoStateChange()
print"the state is==>"m.videoPlayer.state
if m.videoPlayer.state="error"
	m.videoPlayer.visible=false
	m.videoPlayer.control="stop"

else if m.videoPlayer.state="playing"
	'm.videoPlayBackPlay.visible=false
	m.playTimer=0	
	m.theValueOfX=0
	m.theValueOfY=0
	m.speedXvalue.text=""
	m.playTimerControler.control="start"
	m.seekInitiatedffrwd=false
	m.seekInitiatedrwnd=false

	m.playValue=0
else if m.videoPlayer.state="finished"
	m.seekTimerControler.control="stop"
	m.playerInfoInvisibleTimer.control="stop"
	m.playTimerControler.control="stop"

	m.videoPlayer.visible=false
	m.videoPlayer.control="stop"
	


	m.onpress.focusButton=0
	m.detailFocus=0
	updateFocus()
else if m.videoPlayer.state="paused"
	m.playTimerControler.control="stop"

	m.videoPlayBackPlay.visible=true
	m.detailTitleVideoPLaybackVideoPLay.text="| "+m.content.title

end if
end sub
