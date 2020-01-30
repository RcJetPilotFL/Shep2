function init()
    m.jobQueue = {}
    m.port = createObject("roMessagePort")
	  m.top.observeField("requestNormal", m.port)
	  m.top.observeField("searchResults", m.port)
	  m.top.observeField("categoryResults", m.port)



	
	  m.top.functionName = "listen"
	  m.top.control = "run"

end function






function listen() as Void ' Task loop that listens for new requests on field 'request' and for responses
  while (true)
		msg = wait(0, m.port)
		mt = type(msg)
		if mt = "roSGNodeEvent"  ' Received new request (observeField)
			if msg.getField() = "requestNormal"
				makeAPIRequestNormal(msg.getData())
			else if msg.getField() = "searchResults"
				makeAPIRequestSearchResults(msg.getData())
			else if msg.getField() = "categoryResults"
				makeAPIRequestCategoryResults(msg.getData())
			
			
			else
				print "[ERROR] ContentRetriever: unrecognized field '"; msg.getField(); "'"
			end if
		else if mt = "roUrlEvent" ' Received response from API call
      processResponse(msg)
		else
			print "[ERROR] ContentRetriever: unrecognized event type '"; mt; "'"
		end if
	end while
end function


function makeAPIRequestNormal(request as Object) as Boolean
  ' this is called by listen() when the request field is changed
  ' the value of request will be passed in here as a parameter
	if type(request) = "roAssociativeArray"  ' sanity check: should pass in roAA
    context = request.context
    if type(context) = "roSGNode" ' sanity check: request should have one field (context as roSGNode)
        parameters = context.parameters
        if type(parameters) = "roAssociativeArray"
          uri = parameters.uri
          if type(uri) = "roString"
            urlTransfer = CreateObject("roUrlTransfer")
            urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
            urlTransfer.AddHeader("X-Roku-Reserved-Dev-Id", "")
            urlTransfer.InitClientCertificates()
            urlTransfer.setUrl(uri)
            urlTransfer.setPort(m.port)
            if (urlTransfer.AsyncGetToString()) ' response will be caught by listen()
              id = stri(urlTransfer.getIdentity()).trim()
              m.jobQueue[id] = {context:context, transfer: urlTransfer} ' saving the urlTransfer object here is essential to keeping it alive (global scope) until the request is finished
              print "Request to "; uri; " successful."
            else
              print "[ERROR] ContentRetriever: invalid uri: "; uri
            end if
          end if
        end if
    end if
	end if
  return true
end function


function makeAPIRequestSearchResults(request as Object) as Boolean
  ' this is called by listen() when the request field is changed
  ' the value of request will be passed in here as a parameter
	if type(request) = "roAssociativeArray"  ' sanity check: should pass in roAA
    context = request.context
    if type(context) = "roSGNode" ' sanity check: request should have one field (context as roSGNode)
        parameters = context.parameters
        if type(parameters) = "roAssociativeArray"
          uri = parameters.uri
          if type(uri) = "roString"
            urlTransfer = CreateObject("roUrlTransfer")
            urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
            urlTransfer.AddHeader("Content-Type","application/x-www-form-urlencoded")
            urlTransfer.AddHeader("X-Roku-Reserved-Dev-Id", "")
            urlTransfer.InitClientCertificates()
            urlTransfer.setUrl(uri)
            urlTransfer.setPort(m.port)
            valueStr="q="+context.query+"&k="+""
            if (urlTransfer.AsyncPostFromString(valueStr)) ' response will be caught by listen()
              id = stri(urlTransfer.getIdentity()).trim()
              m.jobQueue[id] = {context:context, transfer: urlTransfer} ' saving the urlTransfer object here is essential to keeping it alive (global scope) until the request is finished
              print "Request to "; uri; " successful."
            else
              print "[ERROR] ContentRetriever: invalid uri: "; uri
            end if
          end if
        end if
    end if
	end if
  return true
end function

function makeAPIRequestCategoryResults(request as Object) as Boolean
  ' this is called by listen() when the request field is changed
  ' the value of request will be passed in here as a parameter
	if type(request) = "roAssociativeArray"  ' sanity check: should pass in roAA
    context = request.context
    if type(context) = "roSGNode" ' sanity check: request should have one field (context as roSGNode)
        parameters = context.parameters
        if type(parameters) = "roAssociativeArray"
          uri = parameters.uri
          if type(uri) = "roString"
            urlTransfer = CreateObject("roUrlTransfer")
            urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
            urlTransfer.AddHeader("Content-Type","application/x-www-form-urlencoded")
            urlTransfer.AddHeader("X-Roku-Reserved-Dev-Id", "")
            urlTransfer.InitClientCertificates()
            urlTransfer.setUrl(uri)
            urlTransfer.setPort(m.port)
            valueStr="channel="+context.categoryID
            if (urlTransfer.AsyncPostFromString(valueStr)) ' response will be caught by listen()
              id = stri(urlTransfer.getIdentity()).trim()
              m.jobQueue[id] = {context:context, transfer: urlTransfer} ' saving the urlTransfer object here is essential to keeping it alive (global scope) until the request is finished
              print "Request to "; uri; " successful."
            else
              print "[ERROR] ContentRetriever: invalid uri: "; uri
            end if
          end if
        end if
    end if
	end if
  return true
end function


function processResponse(msg as Object)
  id = stri(msg.GetSourceIdentity()).trim()
	job = m.jobQueue[id]
	if job <> invalid
		result = {
      uri: job.context.parameters.uri,
      parameters: job.context.parameters,
      code: msg.getResponseCode(),
      content: msg.getString(),
	  headers:msg.GetResponseHeaders()
    }
    job.context.response = result ' update response field of context node being watched by caller
		m.jobQueue.delete(id)  ' job has been completed
	else
		print "[ERROR] Received response message for unknown job: "; idkey
	end if
end function



Function ResolveRedirect(str As String) As String
	
	request = CreateObject("roUrlTransfer")
	port = CreateObject("roMessagePort")
	request.setPort(port)
	request.setUrl(str)
	if(request.AsyncGetToString())
		while true
			msg = wait(0,port)
			if type(msg) = "roUrlEvent"
				headers=msg.GetResponseHeaders()
				redirect = headers.location
				print"redirect"redirect
				if ( redirect <> invalid AND redirect <> str )
      print "Old url: " str
      print "Redirect url: " redirect
      str = redirect                
    endif
    return str
				exit while
			end if	
			
		end while
	end if	
End Function



Function rdSerialize(v as dynamic, outformat="BRS" as string) as string
	kq = "" ' for BRS
	if outformat = "JSON" then kq = chr(34)
		out = ""
		v = box(v)
		vType = type(v)
		if (vType = "roString" or vType = "String")
			re = CreateObject("roRegex",chr(34),"")
			v = re.replaceall(v, chr(34)+"+chr(34)+"+chr(34) )
			out = out + chr(34) + v + chr(34)
		else if vType = "roInt"
			out = out + v.tostr()
			else if vType = "roFloat"
			out = out + str(v)
		else if vType = "roBoolean"
			bool = "false"
			if v then bool = "true"
			out = out + bool
		else if vType = "roList" or vType = "roArray"
			out = out + "["
			sep = ""
			for each child in v
				out = out + sep + rdSerialize(child, outformat)
				sep = ","
			end for
			out = out + "]"
		else if vType = "roAssociativeArray"
			out = out + "{"
			sep = ""
			for each key in v
				out = out + sep + kq + key + kq + ":"
				out = out + rdSerialize(v[key], outformat)
				sep = ","
			end for
			out = out + "}"
		else if vType = "roFunction"
			out = out + "(Function)"
			else
			out = out + chr(34) + vType + chr(34)
	end if
	return out
End Function