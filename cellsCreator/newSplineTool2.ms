max modify mode

s = SplineShape ()
updateShape s

extMod = extrude ()
shellMod = shell ()

addmodifier s extMod
addmodifier s shellMod
-- addmodifier s (edit_poly ())

select s

-- bug
-- enableShowEndRes true
-- enableShowEndRes false
-- enableShowEndRes true


modPanel.setCurrentObject s.baseobject 
splineOps.startCreateLine s

showEndResult = true
-- windows.ProcessPostedMessages()
-- showEndResult  true 

-- showEndResult 