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
	m.contentList.itemSize=[scale(1250),scale(285)]
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

	m.top.observeField("visible","onVisibleChange")
end sub


Sub onVisibleChange()

if m.top.visible=true
	m.detailPoster.visible=false
	m.detailTitle.visible=false
	m.detailDescription.visible=false
	m.focusKey=0
	updateFocus()
end if	

ENd SUb

Sub startParse()
m.loadingIndicator.control="start"
m.top.startParse=false
if GetFavorite()<>invalid
	m.jsonData=parseJSON(GetFavorite())
	print"==>GetFavorite()"GetFavorite()
	rowItemSpacing=[]
	m.AllDataArray=[]
	m.index=0

	parentNode=createObject("roSGNode","ContentNode")
	ShelfNode=createObject("roSGNode","ContentNode")
	ShelfNode.title="| My favorites"
	for each item in m.jsonData
		itemNode=createObject("roSGNode","ContentNode")
		if item.yt_thumb<>""
		itemNode.hdPosterURL=item.yt_thumb
		else
		itemNode.hdPosterURL="pkg://images/loading_bitmap.png"
		end if
		itemNode.title=item.video_title
		itemNode.description="contentItem"

		itemNode.shortDescriptionLine1=item.yt_length
		itemNode.fhdPosterURL=item.cover_art
		itemNode.shortDescriptionLine2=StringRemoveHTMLTags2(StringRemoveHTMLTags(item.description))
		itemNode.url=item.url_flv
		itemNode.id=item.id
		itemNode.streamFormat="hls"
		m.AllDataArray.Push(itemNode)
		ShelfNode.appendChild(itemNode)
		m.index+=1
		if m.index=5
			parentNode.appendChild(ShelfNode)
			ShelfNode=createObject("roSGNode","ContentNode")
			m.index=0
		endif
	end for
		if m.index<5
			parentNode.appendChild(ShelfNode)
		endif

	m.contentList.rowHeights=[220]
	m.contentList.content=parentNode

	m.loadingIndicator.control="stop"
	m.focusKey=0
	updateFocus()
end if
End SUb












Sub updateFocus()
print"the focusKey is=>"m.focusKey
if m.focusKey=0
	m.contentList.setFocus(true)

end if

ENd SUb






Sub contentItemSelected()
contentData=m.contentList.content.getChild(m.top.contentItemSelected[0]).getChild(m.top.contentItemSelected[1])

	m.top.catContentData=contentData
	m.top.contentArray=m.AllDataArray


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


Sub startParse2()
m.top.startParse2=false

m.loadingIndicator.control="start"
rowItemSpacing=[]
m.AllDataArray=[]
m.index=0
m.jsonData=parseJSON(GetFavorite())

parentNode=createObject("roSGNode","ContentNode")
ShelfNode=createObject("roSGNode","ContentNode")
ShelfNode.title="My favorites"
for each item in m.jsonData
	itemNode=createObject("roSGNode","ContentNode")
	if item.yt_thumb<>""
	itemNode.hdPosterURL=item.yt_thumb
	else
	itemNode.hdPosterURL="pkg://images/loading_bitmap.png"
	end if
	itemNode.title=item.video_title
	itemNode.description="contentItem"

	itemNode.shortDescriptionLine1=item.yt_length

	itemNode.shortDescriptionLine2=StringRemoveHTMLTags2(StringRemoveHTMLTags(item.description))
	itemNode.url=item.url_flv
	itemNode.id=item.id
	itemNode.streamFormat="hls"
	m.AllDataArray.Push(itemNode)
	ShelfNode.appendChild(itemNode)
	m.index+=1
	if m.index=5
		parentNode.appendChild(ShelfNode)
		ShelfNode=createObject("roSGNode","ContentNode")
		m.index=0
	endif
end for
	if m.index<5 AND m.index<>0
		parentNode.appendChild(ShelfNode)
	endif

m.contentList.rowHeights=[220]
m.contentList.content=parentNode

m.loadingIndicator.control="stop"
m.focusKey=0
updateFocus()
end sub

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