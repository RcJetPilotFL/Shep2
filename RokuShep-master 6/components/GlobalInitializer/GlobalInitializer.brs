sub init()
  contentRetriever = CreateObject("roSGNode", "ContentRetriever")
  ' API paths
  this = {}
  this.BaseURL                    =        "http://holyplaces.woo.media/admin/api/v1/roku/"

  m.global.addFields({
    api: this,
    contentRetriever: contentRetriever,
	
    ' notificationOverlay - added in MainScene init
  })
end sub
