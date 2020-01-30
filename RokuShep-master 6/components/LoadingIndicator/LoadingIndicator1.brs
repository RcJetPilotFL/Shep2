' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub init()
  m.loadingImage = m.top.findNode("LoadingImage")
  m.loadingImage.width = scale(140)
  m.loadingImage.height = scale(140)
  
  m.rotationAnimation = m.top.findNode("RotationAnimation")
  m.fadeAnimation = m.top.findNode("FadeAnimation")
  m.fadeInterpolator = m.top.findNode("FadeInterpolator")
  m.loadingImage.scaleRotateCenter = [scale(70), scale(70)]
end sub

sub onSizeChange()
  m.loadingImage.height = m.top.height
  m.loadingImage.width = m.top.width
  m.loadingImage.scaleRotateCenter = [m.top.width/2, m.top.height/2]
end sub

sub onControl()
  if m.top.control = "start"
    m.top.visible = true
    m.rotationAnimation.control = "start"
  else if m.top.control = "stop"
    m.top.visible = false
    m.rotationAnimation.control = "stop"
  end if
end sub
