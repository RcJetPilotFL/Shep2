Sub init()
m.seekBarPathRed=m.top.findNode("seekBarPathRed")

End SUb

Sub SeekPathMeasureFunc()
'print"m.top.theTotalDuration"m.top.totalVideoDuration
onesecondValue=1000/m.top.totalVideoDuration
'print"m.top.SeekPathMeasure/1000=>"m.top.SeekPathMeasure*onesecondValue
print"m.top.SeekPathMeasure==>"m.top.SeekPathMeasure
print"the onesecondValue is==>"onesecondValue
m.seekBarPathRed.width=m.top.SeekPathMeasure*onesecondValue
print""

ENd SUb