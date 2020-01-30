Sub init()
	m.contentRetriever = m.global.contentRetriever 
	m.loadingIndicator=m.top.findNode("loadingIndicator")
	m.loadingIndicator.translation=[scale(568),scale(299)]

	m.rowlabelfont  = CreateObject("roSGNode", "Font")
	m.rowlabelfont.uri = "pkg://fonts/lato/Lato-Bold.ttf"
	m.rowlabelfont.size = scale(26)

	m.contentList=m.top.findNode("contentList")
	m.contentList.rowLabelFont=m.rowlabelfont
	m.contentList.rowLabelColor="#ffffff"
	m.contentList.translation=[scale(60),scale(400)]
	m.contentList.itemSize=[scale(1250),scale(245)]
	m.contentList.numRows=scale(10)
	m.contentList.itemSpacing=[scale(10),scale(20)]
	m.contentList.focusXOffset=[scale(0)]
	m.contentList.rowItemSize=[[scale(220),scale(168)]]
	m.contentList.rowItemSpacing=[[scale(20),scale(0)]]
	m.contentList.rowLabelOffset=[[scale(5),scale(20)]]
	m.contentList.rowCounterRightOffset=50

	m.detailPoster=m.top.findNode("detailPoster")
	m.detailTitle=m.top.findNode("detailTitle")
	m.detailDescription=m.top.findNode("detailDescription")
	m.titleMarker=m.top.findNode("titleMarker")

	m.top.observeField("visible","onVisibleChange")
end sub


Sub onVisibleChange()

if m.top.visible=true
	m.detailPoster.visible=false
	m.detailTitle.visible=false
	m.detailDescription.visible=false
	m.focusKey=m.focusKey
	updateFocus()
end if	

ENd SUb

Sub startParse()
m.loadingIndicator.control="start"
m.top.startParse=false
m.contentList.visible=false

getNormalURL("https://shepherdsvod.oneconnxt.com/Shepherds_New.json","getNewVideos")


End SUb


sub getNormalURL(search as String, requestType as String)

   makeNormalResponse({uri: search, request_type: requestType })
  print("Attempting to make API request to option:" +search)
end sub




sub makeNormalResponse(parameters as Object)
  context = createObject("RoSGNode","Node")
  if type(parameters) = "roAssociativeArray"
    context.addFields({
      parameters: parameters,
      response: {}
    })
    context.observeField("response","receiveRequestResponse")
    m.contentRetriever.requestNormal = { context: context } ' initiate request and store context node as intermediary
  end if
end sub



sub receiveRequestResponse(msg as Object)

	mt = type(msg)
	if mt = "roSGNodeEvent"
    response = msg.getData()
    rt = type(response)
    if rt = "roAssociativeArray"
		print"response.code==>"response.code
        if response.code = 200			
          requestType = response.parameters.request_type
          if requestType = "getNewVideos"
		  		loadData(response.content)
          end if
        end if
    else
        print "[ERROR] HomeScreen: Expected response of type roAA, received response of type: '"; rt; "'"
    end if
	else
		print "[ERROR] HomeScreen: Received unknown response message of type: '"; mt; "'"
	end if
end sub


Sub loadData(jsonData As Object)

json=parseJSON(jsonData)


m.parentNode=createObject("roSGNode","ContentNode")
for each item in json.playlists
	ShelfNode=createObject("roSGNode","ContentNode")
	ShelfNode.title=item.name
	for each item2 in item.items
		itemNode=createObject("roSGNode","ContentNode")
		if item.yt_thumb<>""
		itemNode.hdPosterURL=item2.thumbnail
		else
		itemNode.hdPosterURL="pkg://images/loading_bitmap.png"
		end if
		itemNode.fhdPosterURL="pkg://images/1280.jpg"
		'itemNode.fhdPosterURL=item2.thumbnail	
		itemNode.title=item2.title
		itemNode.id=item2.id
		itemNode.description="contentItem"
		itemNode.shortDescriptionLine1=item2.content.duration
		itemNode.shortDescriptionLine2=StringRemoveHTMLTags2(StringRemoveHTMLTags(item2.shortDescription))
		itemNode.url=item2.content.videos[0].url
		if Lcase(item2.title).inStr("live")>=0
			itemNode.ClosedCaptions = True
			itemNode.TrackIDSubtitle = "eia608/1"
			itemNode.SubtitleConfig= {trackName: "eia608/1"}
		else
			if Lcase(item2.content.videos[0].url).inStr(".mp4")>=0
				value=item2.content.videos[0].url.Replace(".mp4",".srt")
			end if
			itemNode.ClosedCaptions = True
			itemNode.TrackIDSubtitle = item2.title
			itemNode.SubtitleConfig= {trackName:value}

		end if
		itemNode.streamFormat="Auto"

		ShelfNode.appendChild(itemNode)
	end for
	m.parentNode.appendChild(ShelfNode)
end for




	ShelfNodeoptions=createObject("roSGNode","ContentNode")
	ShelfNodeoptions.title="| Options"


	itemNode=createObject("roSGNode","ContentNode")
	itemNode.title="My Favorite"
	itemNode.description="optionItem"
	itemNode.hdPosterURL="pkg://images/favorite.png"
	ShelfNodeoptions.appendChild(itemNode)




m.parentNode.insertChild(ShelfNodeoptions,m.parentNode.getCHildren(3000,0).Count())


m.contentList.rowHeights=[245]
m.contentList.content=m.parentNode
m.contentList.visible=true
m.loadingIndicator.control="stop"
m.titleMarker.visible=true
m.top.signalBeacon("AppLaunchComplete") 
m.focusKey=0
updateFocus()

ENd Sub


Sub updateFocus()
print"the focusKey is=>"m.focusKey
if m.focusKey=0
	
	'm.contentList.jumpToRowItem=[m.top.contentItemSelected[0],m.top.contentItemSelected[1]]
	m.contentList.setFocus(true)
end if

ENd SUb



Sub contentItemSelected()
contentData=m.contentList.content.getChild(m.top.contentItemSelected[0]).getChild(m.top.contentItemSelected[1])
print"contentData==>"contentData
if contentData.title="Search"
	m.top.showSearchScreen=true
else if contentData.title="Categories"
	m.top.showCategoryScreen=true
else if contentData.title="My Favorite"
	m.top.showFavoriteScreen=true
else
	m.top.contentData=contentData
	'm.top.contentArray=m.contentList.content.getChild(m.top.contentItemSelected[0]).getChildren(30000,0)
end if

End SUB


Sub contentItemFocused()
contentData=m.contentList.content.getChild(m.top.contentItemFocused[0]).getChild(m.top.contentItemFocused[1])
if contentData<>invalid
	m.detailPoster.visible=true
	m.detailTitle.visible=true
	m.detailDescription.visible=true
	m.detailPoster.uri=contentData.fhdPosterURL
	m.detailTitle.text=contentData.title
	m.detailDescription.text=contentData.shortDescriptionLine2
end if
ENd SUb


Function onKeyEvent(key as String, press as Boolean) as Boolean
	handled = false

if press 
	if key="up"
	 
	else if key="down"

	else if key="options"
		
	else if key="back"
		
	end if
end if

	return handled
End Function

function StringRemoveHTMLTags(baseStr as String) as String
    r = createObject("roRegex", "<[^<]+?>", "i")
    return r.replaceAll(baseStr, "")
end function

function StringRemoveHTMLTags2(baseStr as String) as String
    r = createObject("roRegex", "&nbsp;|&idquo;|&rdquo", "i")
    return r.replaceAll(baseStr, "")
end function