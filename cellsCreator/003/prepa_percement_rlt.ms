/*
	maj:
		-- faire evoluer sur le mod�le de la prepa des murs
			-- rafraichir les reglages avec la selection dans le multibox, structure
			-- memoriser les reglages dans un fichier ini
				-- manager les sauvegardes de fichier ini globales et locales
			x- cr�er les calques en fonction du nom du percement

		-- associer un objet avec un type de gabarit
			-- tester si on peu merger des grouge depuis un fichier max seulement par le nom
*/


global cellSetPath = getroot() +"cellsCreator/cellSettings/*"

struct spPerceSet (name, wirecolor, hauteur, allege, debordAv, debordAr, filename)

fn collectLayer pattern: "*" =
(
	local layerFoundAr = #()
	for i = 0 to  (LayerManager.count - 1) do
	(
		l = LayerManager.getLayer i
		
		if  matchpattern l.name pattern: pattern then
		(
			append layerFoundAr l
-- 			"l.name: %\n" l.name
		)
	)
	layerFoundAr
)

fn rafle layerList: #() =
(
	local all = #()
	for l in layerList do
	(
-- 		format "l.name: %\n" l.name
		local tmp
		l.nodes &tmp
-- 		format "tmp: %\n" tmp
		for o in tmp do append all o
	)
	all
)
-- layers = collectLayer pattern: "_*"
-- obj = rafle layerList: layers

-- layers[1].nodes &tmp

try(destroydialog prepaPercementRLT)catch()
rollout prepaPercementRLT "preparation percement v2"
(
	local params = #("open")
	
	local cellSetAr = #()
	local layerStructAr = #()
	
	local cellSetIni -- = getRoot() + "cellsCreator/cellSettings/cellSettings.ini"
	local prepaSuf = "__Splines "
	local gabSuf = "___Gabarits "
	
	local drilSel = undefined
	
	-- UI
	group "configuration:"
	(
		dropdownlist  configDDL "select:"
		button saveBT "save" across: 3 enabled: false
		button saveAsBT "saveAs" enabled: false
		button loadBT "load" enabled: false
	)
	
	group "types percements:"
	(
		multilistbox drillingMLB "percements:"
	)
	
	group "param�tres:"
	(
		spinner heightSP "hauteur:"  type: #worldunits range: [0,500, 215] across: 2
		spinner allegeSP "allege:" type: #worldunits range: [0,500, 0]
		spinner innerSP "debord arriere:" type: #worldunits range: [0,500, 0] across: 2
		spinner outerSP "debord avant:" type: #worldunits range: [0,500, 0]

	)
	
	group "objet associ�:"
	(
		edittext mergeET caption: "objet associ�" readonly: false text: "toto" enabled: false
		button pathBT "..." enabled: false
	)
	
	group "actions:"
	(
		button addToLayerBT "add to layer"
		button adjustBT "adjust gabarits" enabled: false
	)

	button createGabaritsBT "create gabarits"
	
	-- functions
	fn refreshUI =
	(
		configDDL.items = for c in cellSetAr collect (getFilenameFile c)
		
-- 		mursMLB.items = for i = layerStructAr.count to 1 by -1 collect layerStructAr[i].name
		drillingMLB.items = for p in layerStructAr collect p.name
		
-- 		name, wirecolor, hauteur, allege, debordAv, debordAr, filename
		
		if drilsel == undefined then
		(
			format "drilsel: undefined\n"
			heightSP.value = 666
			allegeSP.value = 666
			innerSP.value = 666
			outerSP.value = 666
		)
		else
		(
			heightSP.value = drilsel.hauteur
			allegeSP.value = drilsel.allege
			innerSP.value = drilsel.debordAv
			outerSP.value = drilsel.debordAr
		)
	)
	
	fn loadSettings f =
	(
-- 		format "f:%\n" f
-- 		format "start load\n"
		layerStructAr = #()
		setsAr = getINISetting f "drillSettings"
-- 		format "setsAr: %\n" setsAr
		for o in  setsAr do
		(
-- 			format "%\n" (getINISetting f "drillSettings" o) 
			append layerStructAr (execute(getINISetting f "drillSettings" o))
		)
		layerStructAr
	)
	
	
	fn saveSettings f =
	(
		format "start save\n"
		delIniSetting f "drillSettings"
		
		for l in layerStructAr do
		(
			format "% = %\n" l.name (l as string)
			setINISetting f "drillSettings" l.name  (l as string)
		)
		refreshUI()
	)
	
	
	-- actions
	on prepaPercementRLT open do
	(
		
		loadRolloutParams prepaPercementRLT params
		
		cellSetAr = getfiles cellSetPath
-- 		format "cellSetAr: %\n" cellSetAr
		if cellSetAr.count == 0 then()
		else loadSettings cellSetAr[1]
-- 		format "cellSetAr: %\n" layerStructAr
		refreshUI()
		
	)
	
	on prepaPercementRLT close do
	(
		writeRolloutParams prepaPercementRLT params
	)
	
	on loadBT pressed do
	(		
		local config = cellSetAr[configDDL.selection]
-- 		format "configSel: %\n"  config

		if not doesfileexist config then()
		else 	loadSettings config
		
		refreshUI()
	)
	
	on saveBT pressed do
	(
		local config = cellSetAr[configDDL.selection]
-- 		format "configSel: %\n"  config

		if not doesfileexist config then()
		else 	saveSettings config
		
		refreshUI()
	)
	
	on drillingMLB selectionend do
	(
		selIds =  (drillingMLB.selection as array)
		if selIds.count == 1 then
		(
			drilSel = layerStructAr[selIds[1]]
		)
		else
		(
			drilSel = undefined
		)
		
		format "drilSel: %\n" drilSel
		refreshUI()
		
		-- todo chager les parametres d'une structure
-- 		format "sel: %\n" drillingMLB.selection
	)
	

	
	-- Settings UI
	on heightSP changed val do
	(
		if drilSel == undefined then()
		else drilSel.hauteur = val
	)
	
	on allegeSP changed val do
	(
		if drilSel == undefined then()
		else drilSel.allege = val
	)

	on innerSP changed val do
	(
		if drilSel == undefined then()
		else drilSel.debordAv = val
	)
	
	on outerSP changed val do
	(
		if drilSel == undefined then()
		else drilSel.debordAr = val
	)
	
	
	on addToLayerBT pressed do
	(
		
		local objs = selection as array
		
		if objs.count == 0 or drilSel == undefined then(format "fail1\n")
		else if objs.count > 0 and drilSel != undefined then
		(
			format "start addition\n"
			-- creation du calque
			local layername = prepaSuf + drilSel.name
			l = LayerManager.getLayerFromName layername
			if l == undefined then l = LayerManager.newLayerFromName layername
				
			--  ajouter la selection d'objets au calque selectionn�
			for o in objs do
			(
				l.addnode o
				o.wirecolor = drilSel.wirecolor
				-- appliquer le traitement
			)
			
-- 			createWall objs murSel.hauteur murSel.epaisseur
		)
		else(format "fail2\n")
	)
	
	
	on adjustBT pressed do
	(
-- 		collecter tous les calques de reperes
		local layerList = collectLayer pattern: "__Splines *"
		local objs = rafle layerList: layers
		-- pour chaque calque
			-- trouver les reglages correspondants
		format "objs: %\n" objs
		for o in objs do
		(
			for oneStruct in layerStructAr do
			(
-- 				format " o.layer: % oneStruct.name: %\n" o.layer.name  oneStruct.name
				if o.layer.name == oneStruct.name then
				(
					format "adjust % settings on %\n" oneStruct.name o.name
				)
				else()
			)
		)
			-- collecter les objets du calque
			-- appliquer les reglages
	)
	
	on createGabaritsBT pressed do
	(
			-- pour chaque type de fenetre
		for oneStruct in layerStructAr do
		(
			-- trouver le calques de repere
			l = LayerManager.getLayerFromName (prepaSuf + oneStruct.name)
			
			
			if l == undefined then (format "fail oneStruct: %\n" oneStruct.name)
			else
			(
				-- cr�er les calques de gabarits
				TmpFenLName = gabSuf + oneStruct.name
				TmpfenL = LayerManager.getLayerFromName TmpFenLName
				if TmpfenL == undefined then TmpfenL = LayerManager.newLayerFromName TmpFenLName 
				else
				(
					-- nettoyage des calques temporaire de gabarit avant la cr�ation
					TmpfenL.nodes &fenToDel
					delete fenToDel
				)
				
				-- collecter les objets du calque
				l.nodes &tmpObj
-- 				format "type: %, tmpObj: %\n" oneStruct.name tmpObj
				-- pour chaque objet
				FenExtMod = extrude amount: (oneStruct.hauteur - oneStruct.allege) capStart: on capEnd: on
				
				for o in tmpObj do
				(
					
					
					o2 = copy o
					o2.pos.z = 0.5
					
					-- ajuster l'objet
					format "adjust % settings on %\n" oneStruct.name o.name
					adjustGabaritSpline2 o2 shift1: oneStruct.debordAv shift2: oneStruct.debordAr
					
					-- appliquer les r�glages du calque
					move o2 [0,0,oneStruct.allege]
					addmodifier o2 FenExtMod
					converttopoly o2
					o2.wirecolor = oneStruct.wirecolor
					
					-- placer le gabarit dans le calque
					TmpfenL.addnode o2
				)
			)
		)			
	)
)
-- createdialog prepaPercementRLT


