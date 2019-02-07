/*
maj:
- tester la creation d'un objet correctement orient� en z au point d'impact
- la selection de sous objet au point d'impact(face, edge, spline...)
- prendre en charge les categories objets cach� par raccourcis(geometry, spline, lights)
- prendre en charge les spline

snapMode.hitPoint 
snapMode.node 

*/


try(destroydialog testPickerRLT)catch()
rollout testPickerRLT "Test Picker"
(
	local goodRes
	
	checkbutton pickCB "pick"
	
	tool testTool
	(
		on mousePoint clickno do
		(
			local myRay = mapScreenToWorldRay viewPoint
			local arr = intersectRayScene myRay
			
			format "myRay: %\n" myRay
			
			local viewMatrix =  Inverse(viewport.getTM())
			local viewPos = viewMatrix.pos
			local nearestDist = 1000000
			goodRes = undefined
				
			if arr.count>0 do	
			(				
				for obj in arr where not obj[1].ishidden do
				(					
					tmpDist = distance viewPos obj[2].pos
					
					if tmpDist < nearestDist do
					(
-- 							format "mn: %\n" mn.name
						nearestDist = tmpDist
						goodRes = obj
-- 							format "obj: %\n" obj
					)
				)
			)
			format "goodRes: %\n" goodRes
			
			snapMode.display = false
			snapMode.active = true
			
			format "hitPoint: %\n" snapMode.hitPoint 
			format "node: %\n" snapMode.node 
			
			-- Selectionner une face
			-- ajouter un editmesh sur l'objet
			if isvalidnode snapMode.node then
			(
				format "hit: %\n"(intersectRayEx snapMode.node myRay)
			)
			-- recuperer les trois vertex de la face
			-- dans le poly retourner la face avec les trois vertex
			
			-- selectionner un edge
			
		)
		
		on stop do 
		(
			format "stop\n"
		)
		
	)
	
	on pickCB changed state do
	(
		if state do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool testTool
			)
			pickCB.state = false
		)
	)
)
createdialog testPickerRLT