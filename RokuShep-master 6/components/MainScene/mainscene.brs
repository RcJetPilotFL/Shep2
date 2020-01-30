Sub init()
m.top.backgroundURI=""
m.top.backgroundColor="#121212"

m.HomeScreen=m.top.findNode("HomeScreen")
m.searchScreen=m.top.findNode("searchScreen")
m.categoryScreen=m.top.findNode("categoryScreen")
m.favoriteScreen=m.top.findNode("favoriteScreen")

m.HomeScreen.visible=true
m.HomeScreen.startParse=true

	m.rowlabelfont  = CreateObject("roSGNode", "Font")
	m.rowlabelfont.uri = "pkg://fonts/lato/Lato-Bold.ttf"
	m.rowlabelfont.size = scale(26)

	m.contentList_1=m.top.findNode("contentList_1")
	m.contentList_1.rowLabelFont=m.rowlabelfont
	m.contentList_1.rowLabelColor="#ffffff"
	m.contentList_1.translation=[scale(45),scale(400)]
	m.contentList_1.itemSize=[scale(1250),scale(285)]
	m.contentList_1.numRows=scale(10)
	m.contentList_1.itemSpacing=[scale(10),scale(20)]
	m.contentList_1.focusXOffset=[scale(0)]
	m.contentList_1.rowItemSize=[[scale(220),scale(168)]]
	m.contentList_1.rowItemSpacing=[[scale(20),scale(0)]]
	m.contentList_1.rowLabelOffset=[[scale(5),scale(20)]]
	m.contentList_1.rowCounterRightOffset=50

	m.onpress=m.top.findNode("onpress")
	m.onpress.buttons=["Play"]
	m.onpress.focusedTextColor="#ff0000"

	m.videoPlayer=m.top.findNode("videoPlayer")
	m.videoPlayer.height=scale(720)
	m.videoPlayer.width=scale(1280)

	m.loadingIndicator=m.top.findNode("loadingIndicator")
	m.loadingIndicator.translation=[scale(568),scale(500)]

	m.detailScreen=m.top.findNode("detailScreen")
	m.detailPoster=m.top.findNode("detailPoster")
	m.detailTitle=m.top.findNode("detailTitle")
	m.detailDescription=m.top.findNode("detailDescription")

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

	m.onpress.observeField("buttonSelected","playVideo")
	m.contentList_1.observeField("rowItemSelected","changeDetails")
	m.videoPlayer.observeField("state","onvideoStateChange")
	m.videoPlayer.observeField("bufferingStatus","loadingStatus")
	m.videoPlayer.observeField("duration","checkVideoDuration")

	m.detailInvisibleTimer.observeField("fire","playVideoAutomatic")
	m.playerInfoInvisibleTimer.observeField("fire","playerInfoInvisible")
	m.seekTimerControler.observeField("fire","seekTimerControlerFunc")
	m.playTimerControler.observeField("fire","playTimerControlerFunc")




End Sub

SUb showSearchScreen()
m.HomeScreen.showSearchScreen=false
m.HomeScreen.visible=false
m.searchScreen.focusKey=0
m.searchScreen.visible=true
End SUB

SUb showCategoryScreen()
m.HomeScreen.showCategoryScreen=false
m.HomeScreen.visible=false
m.categoryScreen.startParse=true
m.categoryScreen.visible=true
End SUB

Sub showFavoriteScreen()
m.HomeScreen.showFavoriteScreen=false
m.HomeScreen.visible=false

m.favoriteScreen.startParse=true
m.favoriteScreen.visible=true

ENd Sub

Sub ShowDetailScreenFromHome()
'm.detailInvisibleTimer.control="start"
m.timerValue=0

m.detailScreenFrom="HomeScreen"
m.HomeScreen.showDetailScreen=false
m.HomeScreen.visible=false
m.detailScreen.visible=true
print"m.HomeScreen.contentData==>"m.HomeScreen.contentData
m.detailPoster.uri=m.HomeScreen.contentData.fhdPosterURL
m.detailTitle.text=m.HomeScreen.contentData.title
m.detailDescription.text=m.HomeScreen.contentData.shortDescriptionLine2
m.detailContentData=m.HomeScreen.contentData


if GetResumeTime(m.detailContentData.id)<>invalid
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Resume","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Resume","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Resume","Add to favorites"]

		end if
	end if
else
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Add to favorites"]

		end if
	end if
end if
parentNode=createObject("roSGNode","ContentNode")
shelfNode=createObject("roSGNode","ContentNode")
shelfNode.title="| More in playlist"
'data=m.HomeScreen.content.getChild(m.HomeScreen.contentItemSelected[0])
'for each item in data
''	shelfNode.appendChild(item)
'end for

	'parentNode.appendChild(data)
	'm.contentList_1.content=data
	m.onpress.focusButton=0

m.detailFocus=0
updateFocus()

ENd SUb

SUb ShowDetailScreenFromCategory()
'm.detailInvisibleTimer.control="start"
m.timerValue=0
m.detailScreenFrom="categoryScreen"
m.categoryScreen.showDetailScreen=false
m.categoryScreen.visible=false
m.detailScreen.visible=true
m.detailPoster.uri=m.categoryScreen.catContentData.fhdPosterURL
m.detailTitle.text=m.categoryScreen.catContentData.title
m.detailDescription.text=m.categoryScreen.catContentData.shortDescriptionLine2

m.detailContentData=m.categoryScreen.catContentData

if GetResumeTime(m.detailContentData.id)<>invalid
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Resume","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Resume","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Resume","Add to favorites"]

		end if
	end if
else
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		print"favoritesContents==>"favoritesContents
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Add to favorites"]

		end if
	end if
end if
parentNode=createObject("roSGNode","ContentNode")
shelfNode=createObject("roSGNode","ContentNode")
shelfNode.title="More in feature"

'for each item in m.categoryScreen.contentArray
''	shelfNode.appendChild(item)
'end for
''	parentNode.appendChild(shelfNode)
''	m.contentList_1.content=parentNode
	m.onpress.focusButton=0

m.detailFocus=0
updateFocus()

End Sub

Sub ShowDetailScreenFromfavorite()
'm.detailInvisibleTimer.control="start"
m.timerValue=0
m.detailScreenFrom="favoriteScreen"
m.favoriteScreen.showDetailScreen=false
m.favoriteScreen.visible=false
m.detailScreen.visible=true
m.detailPoster.uri=m.favoriteScreen.catContentData.fhdPosterURL
m.detailTitle.text=m.favoriteScreen.catContentData.title
m.detailDescription.text=m.favoriteScreen.catContentData.shortDescriptionLine2

m.detailContentData=m.favoriteScreen.catContentData

if GetResumeTime(m.detailContentData.id)<>invalid
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Resume","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		print"favoritesContents==>"favoritesContents
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Resume","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Resume","Add to favorites"]

		end if
	end if
else
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		print"favoritesContents==>"favoritesContents
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Add to favorites"]

		end if
	end if
end if
parentNode=createObject("roSGNode","ContentNode")
shelfNode=createObject("roSGNode","ContentNode")
shelfNode.title="More in feature"


'for each item in m.favoriteScreen.contentArray
''	shelfNode.appendChild(item)
'end for
''	parentNode.appendChild(shelfNode)
''	m.contentList_1.content=parentNode
	m.onpress.focusButton=0

m.detailFocus=0
updateFocus()


ENd SUB 

SUb ShowDetailScreenFromSearch()
'm.detailInvisibleTimer.control="start"
m.timerValue=0
m.detailScreenFrom="searchScreen"
print"m.categoryScreen.contentData==>"m.searchScreen.searchContentData

m.searchScreen.showDetailScreen=false
m.searchScreen.visible=false
m.detailScreen.visible=true
m.detailPoster.uri=m.searchScreen.searchContentData.fhdPosterURL
m.detailTitle.text=m.searchScreen.searchContentData.title
m.detailDescription.text=m.searchScreen.searchContentData.shortDescriptionLine2
m.detailContentData=m.searchScreen.searchContentData

if GetResumeTime(m.detailContentData.id)<>invalid
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Resume","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		print"favoritesContents==>"favoritesContents
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Resume","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Resume","Add to favorites"]

		end if
	end if
else
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		print"favoritesContents==>"favoritesContents
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Add to favorites"]

		end if
	end if
end if

parentNode=createObject("roSGNode","ContentNode")
shelfNode=createObject("roSGNode","ContentNode")
shelfNode.title="More in feature"

for each item in m.searchScreen.searchContentArray
	shelfNode.appendChild(item)
end for
	parentNode.appendChild(shelfNode)
	m.contentList_1.content=parentNode
m.onpress.focusButton=0

m.detailFocus=0
updateFocus()

ENd SUb

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

Sub playVideoAutomatic()
m.timerValue+=1
if m.timerValue=3
	m.detailInvisibleTimer.control="stop"
	m.timerValue=0
	if GetResumeTime(m.detailContentData.id)<>invalid
		m.videoPlayer.content=m.detailContentData
		m.videoPlayer.visible=true
		m.videoPlayer.seek=GetResumeTime(m.detailContentData.id).toInt()
		m.videoPlayer.enableTrickPlay=false
		m.videoPlayer.enableUI=false
		m.videoPlayer.control="play"
		m.detailFocus=2
		updateFocus()
	else if GetResumeTime(m.detailContentData.id)=invalid
		m.videoPlayer.content=m.detailContentData
		m.videoPlayer.visible=true
		m.videoPlayer.enableTrickPlay=false
		m.videoPlayer.enableUI=false
		m.videoPlayer.control="play"
		m.detailFocus=2
		updateFocus()

	end if
endif

End Sub

Sub playVideo()
m.detailInvisibleTimer.control="stop"
?"the detailContentData=>"m.detailContentData.SUBTITLECONFIG
if GetResumeTime(m.detailContentData.id)<>invalid
	if m.onpress.buttonSelected=0
		m.videoPlayer.content=m.detailContentData
		m.videoPlayer.visible=true
		m.videoPlayer.enableTrickPlay=false
		m.videoPlayer.enableUI=false
		m.videoPlayer.control="play"
		m.detailFocus=2
		updateFocus()
	else if m.onpress.buttonSelected=1
		m.videoPlayer.content=m.detailContentData
		m.videoPlayer.visible=true
		m.videoPlayer.enableTrickPlay=false
		m.videoPlayer.enableUI=false
		m.videoPlayer.seek=GetResumeTime(m.detailContentData.id).toInt()
		m.videoPlayer.control="play"
		m.detailFocus=2
		updateFocus()
	else if m.onpress.buttonSelected=2
		if GetFavorite()=invalid
			favoriteAssoc=[]
			favoriteItem={}
			favoriteItem.video_title=m.detailContentData.title
			favoriteItem.yt_thumb=m.detailContentData.hdPosterURL
			favoriteItem.cover_art=m.detailContentData.fhdPosterURL	
			favoriteItem.id=m.detailContentData.id
			favoriteItem.duration=m.detailContentData.shortDescriptionLine1
			favoriteItem.description=m.detailContentData.shortDescriptionLine2
			favoriteItem.url_flv=m.detailContentData.url
			favoriteItem.streamFormat=m.detailContentData.streamFormat
			favoriteAssoc.Push(favoriteItem)
			SetFavorite(FormatJSON(favoriteAssoc))
			m.onpress.buttons=["Watch Now","Resume","Remove from favorites"]

		else if GetFavorite()<>invalid
			index=0
			m.deleted="false"
			favoritesContents=parseJSON(GetFavorite())
			print"favoritesContents==>"favoritesContents
			for each item in favoritesContents
				index+=1
				if m.detailContentData.id=item.id
					m.deleted="true"
					favoritesContents.Delete(index-1)
					SetFavorite(FormatJSON(favoritesContents))
					m.onpress.buttons=["Watch Now","Resume","Add to favorites"]
				end if
			end for


			if m.deleted="false"
				favoriteItem={}
				favoriteItem.video_title=m.detailContentData.title
				favoriteItem.yt_thumb=m.detailContentData.hdPosterURL
				favoriteItem.cover_art=m.detailContentData.fhdPosterURL	
				favoriteItem.id=m.detailContentData.id
				favoriteItem.duration=m.detailContentData.shortDescriptionLine1
				favoriteItem.description=m.detailContentData.shortDescriptionLine2
				favoriteItem.url_flv=m.detailContentData.url
				favoriteItem.streamFormat=m.detailContentData.streamFormat
				favoritesContents.Push(favoriteItem)
				SetFavorite(FormatJSON(favoritesContents))
				m.onpress.buttons=["Watch Now","Resume","Remove from favorites"]
			end if
		end if
		m.detailFocus=0
		updateFocus()
	end if
else if GetResumeTime(m.detailContentData.id)=invalid
	if m.onpress.buttonSelected=0
		m.videoPlayer.content=m.detailContentData
		m.videoPlayer.visible=true
		m.videoPlayer.enableTrickPlay=false
		m.videoPlayer.enableUI=false
		m.videoPlayer.control="play"
		m.detailFocus=2
		updateFocus()
	else if m.onpress.buttonSelected=1
		if GetFavorite()=invalid 
			favoriteAssoc=[]
			favoriteItem={}
			favoriteItem.video_title=m.detailContentData.title
			favoriteItem.yt_thumb=m.detailContentData.hdPosterURL
			favoriteItem.cover_art=m.detailContentData.fhdPosterURL	
			favoriteItem.id=m.detailContentData.id
			favoriteItem.duration=m.detailContentData.shortDescriptionLine1
			favoriteItem.description=m.detailContentData.shortDescriptionLine2
			favoriteItem.url_flv=m.detailContentData.url
			favoriteItem.streamFormat=m.detailContentData.streamFormat
			favoriteAssoc.Push(favoriteItem)
			SetFavorite(FormatJSON(favoriteAssoc))
			m.onpress.buttons=["Watch Now","Remove from favorites"]

		else if GetFavorite()<>invalid
			index=0
			m.deleted="false"
			favoritesContents=parseJSON(GetFavorite())
			for each item in favoritesContents
				index+=1
				if m.detailContentData.id=item.id
					m.deleted="true"
					favoritesContents.Delete(index-1)
					SetFavorite(FormatJSON(favoritesContents))
					m.onpress.buttons=["Watch Now","Add to favorites"]
				end if
			end for

			if m.deleted="false"
				favoriteItem={}
				favoriteItem.video_title=m.detailContentData.title
				favoriteItem.yt_thumb=m.detailContentData.hdPosterURL
				favoriteItem.cover_art=m.detailContentData.fhdPosterURL	
				favoriteItem.id=m.detailContentData.id
				favoriteItem.duration=m.detailContentData.shortDescriptionLine1
				favoriteItem.description=m.detailContentData.shortDescriptionLine2
				favoriteItem.url_flv=m.detailContentData.url
				favoriteItem.streamFormat=m.detailContentData.streamFormat
				favoritesContents.Push(favoriteItem)
				SetFavorite(FormatJSON(favoritesContents))
				m.onpress.buttons=["Watch Now","Remove from favorites"]
			end if
		end if
		m.detailFocus=0
		updateFocus()
	end if
end if
ENd sub

Sub loadingStatus()
'print"the buffering status is==>"m.videoPlayer.bufferingStatus
if m.videoPlayer.bufferingStatus<>invalid
	m.videoPlayBackLoad.visible=true
	m.detailPosterVideoPLayback.uri=m.detailContentData.fhdPosterURL
	m.detailTitleVideoPLaybackVideoPLayback.text=m.detailContentData.title
	m.detailDescriptionVideoPLaybackVideoPLayback.text=m.detailContentData.shortDescriptionLine2
	m.detailTitleVideoPLaybackLoadIngNumber.text=m.videoPlayer.bufferingStatus.percentage.toStr()+"%"
	m.loadingIndicator.control="start"
else
	m.videoPlayBackLoad.visible=false
	m.loadingIndicator.control="stop"
end if
ENd sub


Sub changeDetails()
contentData=m.contentList_1.content.getChild(m.contentList_1.rowItemSelected[0]).getChild(m.contentList_1.rowItemSelected[1])
'm.detailInvisibleTimer.control="start"
m.timerValue=0
m.detailPoster.uri=contentData.fhdPosterURL
m.detailTitle.text=contentData.title
m.detailDescription.text=contentData.shortDescriptionLine2
m.detailContentData=contentData

if GetResumeTime(m.detailContentData.id)<>invalid
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Resume","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		print"favoritesContents==>"favoritesContents
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Resume","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Resume","Add to favorites"]

		end if
	end if
else
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Add to favorites"]
	else
		favoritesContents=parseJSON(GetFavorite())
		print"favoritesContents==>"favoritesContents
		m.favorites="false"
		for each item in favoritesContents
			if m.detailContentData.id=item.id
				m.favorites="true"
				m.onpress.buttons=["Watch Now","Remove from favorites"]
			end if
		end for
		if m.favorites="false"
			m.onpress.buttons=["Watch Now","Add to favorites"]

		end if
	end if
end if
ENd SUB

Sub onvideoStateChange()
print"the state is==>"m.videoPlayer.state
if m.videoPlayer.state="error"
	m.videoPlayer.visible=false
	m.videoPlayer.control="stop"
	m.detailFocus=0
	updateFocus()
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
	DeleteResumeTime(m.detailContentData.id)
	m.videoPlayer.visible=false
	m.videoPlayer.control="stop"
	
	
	if GetFavorite()=invalid
		m.onpress.buttons=["Watch Now","Add to favorites"]
	end if

	m.onpress.focusButton=0
	m.detailFocus=0
	updateFocus()
else if m.videoPlayer.state="paused"
	m.playTimerControler.control="stop"

	m.videoPlayBackPlay.visible=true
	m.detailTitleVideoPLaybackVideoPLay.text="| "+m.detailContentData.title

end if
end sub

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

Function onKeyEvent(key as String, press as Boolean) as Boolean
	handled = false

	if press 
	 if key="back"
	 	if m.videoPlayer.visible=false
			if m.searchScreen.visible=true 
				m.searchScreen.visible=false
				m.HomeScreen.visible=true
				handled=true
			else if m.categoryScreen.visible=true
				m.categoryScreen.visible=false
				m.HomeScreen.visible=true
				handled=true
			else if m.favoriteScreen.visible=true
				m.favoriteScreen.visible=false
				m.HomeScreen.visible=true
				handled=true
			else if m.detailScreenFrom="HomeScreen"
				m.detailScreen.visible=false
				'm.HomeScreen.startParse=true
				m.HomeScreen.visible=true
				m.detailScreenFrom=""
				handled=true
			else if m.detailScreenFrom="categoryScreen"
				m.detailScreen.visible=false
				m.categoryScreen.startParse2=true
				m.categoryScreen.visible=true
				m.detailScreenFrom=""
				handled=true
			else if m.detailScreenFrom="favoriteScreen"
				m.detailScreen.visible=false
				m.favoriteScreen.startParse2=true
				m.favoriteScreen.visible=true
				m.detailScreenFrom=""
				handled=true
			else if m.detailScreenFrom="searchScreen"
				m.detailScreen.visible=false
				m.searchScreen.startParse2=true
				m.searchScreen.focusKey=1
				m.searchScreen.visible=true

				m.detailScreenFrom=""
				handled=true
			end if 
		else if m.videoPlayer.visible=true
			m.seekTimerControler.control="stop"
			m.playerInfoInvisibleTimer.control="stop"
			m.playTimerControler.control="stop"

			if m.showPlayerControl=true
				showPlayerControl(false)
			end if
			m.videoPlayer.visible=false
			SetResumeTime(m.detailContentData.id,m.videoPlayer.position.toStr())
			if GetResumeTime(m.detailContentData.id)<>invalid
				if GetFavorite()=invalid
					m.onpress.buttons=["Watch Now","Resume","Add to favorites"]
				else
					favoritesContents=parseJSON(GetFavorite())
					print"favoritesContents==>"favoritesContents
					m.favorites="false"
					for each item in favoritesContents
						if m.detailContentData.id=item.id
							m.favorites="true"
							m.onpress.buttons=["Watch Now","Resume","Remove from favorites"]
						end if
					end for
					if m.favorites="false"
						m.onpress.buttons=["Watch Now","Resume","Add to favorites"]

					end if
				end if			
			end if
			m.videoPlayer.control="stop"
			m.detailFocus=0
			updateFocus()
			handled=true
		end if
		handled=true
	  else if key="down"
	  		'if m.detailFocus=0 and m.detailScreen.visible=true
	  			'm.detailFocus=1
	  			'updateFocus()
	  			'handled=true
	  		'end if
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


SUb seekTimerControlerFunc()
	if m.seekInitiatedrwnd=true
		if m.seekDuration>5
			m.totalDurationLeft=m.totalDurationLeft+(m.theValueOfY*5)
			m.seekDuration-=(m.theValueOfY*5)
			m.videoPlayerUI.SeekPathMeasure=m.seekDuration
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
	else if m.seekInitiatedffrwd=true
		'print"m.theValueOfX==>"m.theValueOfX
		if m.totalDurationLeft>5
			m.totalDurationLeft=m.totalDurationLeft-(m.theValueOfX*5)
			m.seekDuration+=(m.theValueOfX*5)
			m.videoPlayerUI.SeekPathMeasure=m.seekDuration
			hours=m.totalDurationLeft\60
			minutes=m.totalDurationLeft MOD 60
			'print"the duration is==>"hours.toStr()+":"minutes.toStr()
			hoursSeek=m.seekDuration\60
			minutesSeek=m.seekDuration MOD 60
			'print"the duration is==>"hoursSeek.toStr()+":"minutesSeek.toStr()
			m.videoPlayerUI.timeCountAText=hours.toStr()+":"+minutes.toStr()
			m.videoPlayerUI.timeCountBText=hoursSeek.toStr()+":"+minutesSeek.toStr()
		end if
	end if
	
End sub

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