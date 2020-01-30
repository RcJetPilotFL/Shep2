Sub init()
	m.contentRetriever = m.global.contentRetriever 
	m.loadingIndicator=m.top.findNode("loadingIndicator")
	m.loadingIndicator.translation=[scale(568),scale(299)]

	m.rowlabelfont  = CreateObject("roSGNode", "Font")
	m.rowlabelfont.uri = "pkg://fonts/lato/Lato-Bold.ttf"
	m.rowlabelfont.size = scale(26)

	m.categoryList=m.top.findNode("categoryList")
	m.categoryList.rowLabelFont=m.rowlabelfont
	m.categoryList.rowLabelColor="#ffffff"
	m.categoryList.translation=[scale(60),scale(250)]
	m.categoryList.itemSize=[scale(1250),scale(285)]
	m.categoryList.numRows=scale(10)
	m.categoryList.itemSpacing=[scale(10),scale(20)]
	m.categoryList.focusXOffset=[scale(0)]
	m.categoryList.rowItemSize=[[scale(220),scale(168)]]
	m.categoryList.rowItemSpacing=[[scale(20),scale(0)]]
	m.categoryList.rowLabelOffset=[[scale(5),scale(20)]]
	m.categoryList.rowCounterRightOffset=50

	m.contentList=m.top.findNode("contentList")
	m.contentList.rowLabelFont=m.rowlabelfont
	m.contentList.rowLabelColor="#ffffff"
	m.contentList.translation=[scale(60),scale(400)]
	m.contentList.itemSize=[scale(1250),scale(285)]
	m.contentList.numRows=scale(10)
	m.contentList.itemSpacing=[scale(10),scale(20)]
	m.contentList.focusXOffset=[scale(0)]
	m.contentList.rowItemSize=[[scale(220),scale(168)]]
	m.contentList.rowItemSpacing=[[scale(20),scale(0)]]
	m.contentList.rowLabelOffset=[[scale(5),scale(20)]]
	m.contentList.rowCounterRightOffset=50


	m.detailTitle=m.top.findNode("detailTitle")
	m.titleMarker=m.top.findNode("titleMarker")
	m.detailDescription=m.top.findNode("detailDescription")

	m.top.observeField("visible","onVisibleChange")
end sub


Sub onVisibleChange()

if m.top.visible=true

	m.detailTitle.visible=false
	m.titleMarker.visible=false

	m.detailDescription.visible=false

	m.focusKey=m.focusKey
	updateFocus()
end if	

ENd SUb

Sub startParse()
m.loadingIndicator.control="start"
m.top.startParse=false
getNormalURL(m.global.api.BaseURL+"getcategories.php","getCategories")


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
          if requestType="getCategories"
		  		'm.categoryContent=parseJSON(response.content)
		  		loadCategories(response.content)
		  else if requestType="getCategoryContent"
		  		loadCategoryContent(response.content)
          end if
        end if
    else
        print "[ERROR] HomeScreen: Expected response of type roAA, received response of type: '"; rt; "'"
    end if
	else
		print "[ERROR] HomeScreen: Received unknown response message of type: '"; mt; "'"
	end if
end sub




Sub updateFocus()
print"the focusKey is=>"m.focusKey
if m.focusKey=0
	m.categoryList.setFocus(true)
else if m.focusKey=1
	m.contentList.jumpToRowItem=[m.top.contentItemSelected[0],m.top.contentItemSelected[1]]
	m.contentList.setFocus(true)
end if

ENd SUb


SUb loadCategories(jsonData as Object)
jsonData=parseJSON(jsonData)
parentNode=createObject("RoSGNode","ContentNode")
ShelfNode=createObject("RoSGNode","ContentNode")
ShelfNode.title=""
for each item in jsonData
	itemNode=createObject("RoSGNode","ContentNode")
	itemNode.title=item.title
	itemNode.hdPosterURL="pkg://images/categoryBG.png"
	itemNode.description="categoryItem"
	itemNode.id=item.id
	ShelfNode.appendChild(itemNode)
end for

parentNode.appendChild(ShelfNode)
m.categoryList.content=parentNode
m.loadingIndicator.control="stop"
m.focusKey=0
updateFocus()
ENd SUB

Sub categoryItemSelected()
categoryData=m.categoryList.content.getChild(m.top.categoryItemSelected[0]).getChild(m.top.categoryItemSelected[1])
m.loadingIndicator.control="start"
m.categoryList.visible=false

	m.categoryTitle=categoryData.title
	m.categoryID=categoryData.id
	getcategoryDataURL(m.global.api.BaseURL+"getVideos.php","getCategoryContent")


ENd SUb



sub getcategoryDataURL(search as String, requestType as String)

   makeCategoryDataResponse({uri: search, request_type: requestType })
  print("Attempting to make API request to option:" +search)
end sub




sub makeCategoryDataResponse(parameters as Object)
  context = createObject("RoSGNode","Node")
  if type(parameters) = "roAssociativeArray"
    context.addFields({
      parameters: parameters,
      categoryID:m.categoryID
      response: {}
    })
    context.observeField("response","receiveRequestResponse")
    m.contentRetriever.categoryResults = { context: context } ' initiate request and store context node as intermediary
  end if
end sub

Sub loadCategoryContent(json As Object)
m.jsonData=parseJSON(json)
rowItemSpacing=[]
m.index=0

parentNode=createObject("roSGNode","ContentNode")
ShelfNode=createObject("roSGNode","ContentNode")
ShelfNode.title="| "+m.categoryTitle
for each item in m.jsonData
	itemNode=createObject("roSGNode","ContentNode")
	if item.yt_thumb<>""
	itemNode.hdPosterURL=item.yt_thumb
	else
	itemNode.hdPosterURL="pkg://images/loading_bitmap.png"
	end if
	itemNode.title=item.video_title
	itemNode.description="contentItem"
	if item.yt_length<>""
		duration=item.yt_length.toInt()/60
		itemNode.shortDescriptionLine1=duration.toStr()+":00"
	end if
	itemNode.shortDescriptionLine2=StringRemoveHTMLTags2(StringRemoveHTMLTags(item.description))
	itemNode.url=item.url_flv
	itemNode.id=item.id
	itemNode.streamFormat="hls"
	ShelfNode.appendChild(itemNode)
	m.index+=1
	if m.index=5 AND m.index<>0
		parentNode.appendChild(ShelfNode)
		ShelfNode=createObject("roSGNode","ContentNode")
		m.index=0
	endif
end for
	if m.index<5
		parentNode.appendChild(ShelfNode)
	endif
	m.contentList.rowHeights=[220]
'm.contentList.rowHeights=rowItemSpacing
m.contentList.content=parentNode
if m.categoryList.visible=false
	m.contentList.visible=true
end if
m.loadingIndicator.control="stop"
m.focusKey=1
updateFocus()

End Sub

Sub contentItemSelected()
contentData=m.contentList.content.getChild(m.top.contentItemSelected[0]).getChild(m.top.contentItemSelected[1])

	m.top.catContentData=contentData
	m.top.contentArray=m.contentList.content.getChild(m.top.contentItemSelected[0]).getChildren(30000,0)


End SUB

Sub contentItemFocused()
contentData=m.contentList.content.getChild(m.top.contentItemFocused[0]).getChild(m.top.contentItemFocused[1])
if contentData<>invalid

	m.detailTitle.visible=true
	m.titleMarker.visible=true

	m.detailDescription.visible=true


m.detailTitle.text=contentData.title
m.detailDescription.text=contentData.shortDescriptionLine2
endif
ENd SUb

Sub startParse2()
m.top.startParse2=false
m.loadingIndicator.control="start"
getcategoryDataURL(m.global.api.BaseURL+"getVideos.php","getCategoryContent")
end sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
	handled = false

if press 
	if key="up"
	 
	else if key="down"

	else if key="options"
		
	else if key="back"
		if m.focusKey=1
			m.contentList.visible=false

			m.detailTitle.visible=false
			m.titleMarker.visible=false

			m.detailDescription.visible=false

			m.categoryList.visible=true
			m.focusKey=0
			updateFocus()
			handled=true
		end if
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