Sub Init()
    'input=CreateObject("roInput")
    'm.port=createobject("roMessagePort")
    'input.setMessagePort(m.port)
    m.top.functionName = "ListenInput"
End Sub

function ListenInput()
    port=createobject("roMessagePort")
    InputObject=createobject("roInput")
    InputObject.setmessageport(port)

    while true
      msg=wait(0, port)
      
      ? "type(msg)" ; type(msg)
      
      if type(msg)="roInputEvent" then
        print "INPUT EVENT!" ; msg.isInput()
        if msg.isInput()
          inputData = msg.getInfo()
          'print inputData'
          for each item in inputData
            print item  +": " inputData[item]
          end for

          ' pass the deeplink to UI
          if inputData.DoesExist("mediaType") and inputData.DoesExist("contentID")
            deeplink = {
                id: inputData.contentID
                type: inputData.mediaType
            }
            print "got input deeplink= "; deeplink
            m.top.inputData = deeplink
          end if
        end if
      end if
    end while
end function
