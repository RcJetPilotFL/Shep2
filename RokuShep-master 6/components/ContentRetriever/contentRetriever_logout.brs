sub init()
print"contentRetriever_logout"
m.top.functionName="doLogout"
m.top.control="RUN"

end sub




Function doLogout() As Void
m.top.logout=false

DeleteToken()

End Function