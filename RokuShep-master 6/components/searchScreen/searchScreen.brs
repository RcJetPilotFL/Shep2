Sub init()
m.contentRetriever = m.global.contentRetriever
    rowlabelfont  = CreateObject("roSGNode", "Font")
	rowlabelfont.uri = "pkg://fonts/lato/Lato-Bold.ttf"
	rowlabelfont.size = scale(20)
	
 font_28  = CreateObject("roSGNode", "Font")
 font_28.uri = "pkg://fonts/lato/Lato-BoldItalic.ttf"
 font_28.size = scale(28)
 m.Nav_text=m.top.findNode("Nav_text")
 m.Nav_text.translation=[scale(40),scale(100)]
 m.Nav_text.width=scale(1280)
 m.Nav_text.font=font_28
 
 font_20  = CreateObject("roSGNode", "Font")
 font_20.uri = "pkg://fonts/lato/Lato-Italic.ttf"
 font_20.size = scale(20)
 m.Nav_subtext=m.top.findNode("Nav_subtext")
 m.Nav_subtext.translation=[scale(40),scale(140)]
 m.Nav_subtext.width=scale(1280)
 m.Nav_subtext.font=font_20
	

	
 m.Keyboard=m.top.findNode("Keyboard")
 m.Keyboard.translation=[scale(40),scale(200)]
 m.Keyboard.width=scale(0)
 m.Keyboard.height=scale(0)
 
  font_24  = CreateObject("roSGNode", "Font")
  font_24.uri = "pkg://fonts/lato/Lato-Bold.ttf"
  font_24.size = scale(24)
  m.noResultFound=m.top.findNode("noResultFound")
  m.noResultFound.translation=[scale(460),scale(0)]
  m.noResultFound.width=scale(820)
  m.noResultFound.height=scale(720)
  m.noResultFound.font=font_24
 
m.loadingIndicator=m.top.findNode("loadingIndicator")
m.loadingIndicator.translation=[scale(730),scale(299)]
 
 m.contentList=m.top.findNode("contentList")
 m.contentList.translation=[scale(475),scale(105)]
	m.contentList.itemSize=[scale(800),scale(205)]
	m.contentList.numRows=scale(10)
	m.contentList.itemSpacing=[scale(10),scale(20)]
	m.contentList.focusXOffset=[scale(0)]
	m.contentList.rowItemSize=[[scale(220),scale(168)]]
	m.contentList.rowItemSpacing=[[scale(20),scale(0)]]
	m.contentList.rowLabelOffset=[[scale(5),scale(20)]]

 m.contentList.focusXOffset=[scale(0)]
 
 m.contentList.rowLabelFont=rowlabelfont
 m.contentList.rowLabelColor="#ffffff"
 

 

 


m.Keyboard.textEditBox.textColor="#ffffff"
m.top.observeField("visible","OnVisibleChange")

m.keyboard.ObserveField("text", "textEntered")

m.rowItemIDs=[]
end Sub




Sub OnVisibleChange()

	if m.top.visible=true	
		m.focusKey=m.top.focusKey
		updateFocus()	
	end if
	

End Sub



Sub updateFocus()

	if m.focusKey=0		
		m.Keyboard.setFocus(true)
	 
	 else if m.focusKey=1	
		
		m.contentList.setFocus(true)
	end if


End Sub


Sub textEntered()

	m.searchText=m.Keyboard.text
	if m.searchText<>""
		getSearchResults(m.global.api.BaseURL+"search.php","searchResults")
	else
		m.contentList.visible=false
		m.noResultFound.visible=false
	end if
	
End Sub


sub getSearchResults(search as String, requestType as String)
   m.loadingIndicator.control="start"
   makeSearchResults({uri: search, request_type: requestType })
  print("Attempting to make API request to option:" +search)
end sub



sub makeSearchResults(parameters as Object)



  context = createObject("RoSGNode","Node")
  if type(parameters) = "roAssociativeArray"
    context.addFields({
      parameters: parameters,
      query:m.searchText,
      response: {}
    })
    context.observeField("response","receiveRequestResponse")
    m.contentRetriever.searchResults = { context: context } ' initiate request and store context node as intermediary
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
          if requestType = "searchResults"
				m.loadingIndicator.control="stop"
				showSearchContent(response.content)
          end if
        end if
    else
        print "[ERROR] HomeScreen: Expected response of type roAA, received response of type: '"; rt; "'"
    end if
	else
		print "[ERROR] HomeScreen: Received unknown response message of type: '"; mt; "'"
	end if
end sub


Sub showSearchContent(json As Object)
	json=ParseJSON(json)
	m.contentData=[]
	if json<>invalid
		if json.count()>0 
			rowItemSpacing=[]
			parentNode=createObject("roSGNode","ContentNode")
			ShelfNode=createObject("roSGNode","ContentNode")
			ShelfNode.title="Search Results"
			m.index=0
			for each item in json
				'print"the item is==>"item
				itemNode=createObject("roSGNode","ContentNode")
				if item.yt_thumb<>""
				itemNode.hdPosterURL=item.yt_thumb
				else
				itemNode.hdPosterURL="pkg://images/loading_bitmap.png"
				end if
				itemNode.title=item.video_title
				if item.description<>invalid
					itemNode.shortDescriptionLine2=StringRemoveHTMLTags2(StringRemoveHTMLTags(item.description))
				end if
				itemNode.url=item.url_flv
				itemNode.id=item.id
				itemNode.streamFormat="hls"
				itemNode.description="searchItem"
				m.index+=1
				m.contentData.Push(itemNode)
				ShelfNode.appendChild(itemNode)

				if m.index MOD 3=0
				rowItemSpacing.Push(205)
				parentNode.appendChild(ShelfNode)
				ShelfNode=createObject("roSGNode","ContentNode")
				m.index=0
				end if

			end for

			if m.index < 3 and m.index<>0
				rowItemSpacing.Push(205)
				parentNode.appendChild(ShelfNode)
				
			end if

			m.contentList.rowHeights=rowItemSpacing
			m.contentList.content=parentNode
			m.contentList.jumpToRowItem=[m.top.contentItemSelected[0],m.top.contentItemSelected[1]]
			m.contentList.visible=true
		else 

			m.contentList.visible=false
			m.noResultFound.visible=true
			m.noResultFound.text="No result found for the query '"+m.keyboard.text+"'."

		end if
	else

		m.contentList.visible=false
		m.noResultFound.visible=true
		m.noResultFound.text="No result found for the query '"+m.keyboard.text+"'."
	end if
End Sub


Sub contentItemSelected()
contentData=m.contentList.content.getChild(m.top.contentItemSelected[0]).getChild(m.top.contentItemSelected[1])

	m.top.searchContentData=contentData
	m.top.searchContentArray=m.contentData


End SUB

Sub startParse2()
m.top.startParse2=false
textEntered()
end sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
	handled = false

	if press 
		if key="right"
			if m.focusKey=0
			 if m.contentList.visible=true
				m.focusKey=1
				updateFocus()
				handled=true
			 end if		  
			end if	
			
		 else if key="left"
			if m.focusKey=1
				m.focusKey=0
				updateFocus()
				handled=true			
			end if	
			
		 else if key="down"
				
			
		  else if key="up"
			
			
			
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