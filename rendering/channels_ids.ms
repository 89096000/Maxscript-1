/*
 faire travailler au choix sur la scene, les objets visibles ou la selection d'objet
*/


-- appliquer une id de materiau aux materiaux des object selectionn�s
sel = selection as array
matSel = for s in sel where s.material != undefined collect s.material
	
matAr = #()
for m in matSel do
(
	tmpMatAr = getclassinstances vrayMtl target: m
	for tmpM in tmpMatAr do appendifunique matAr tmpM
)
matAr

-- collecter les ids de materiau dans la scene
sceneMat = getclassinstances vrayMtl target: scenematerials
usedIds = #()
for m in sceneMat do
(
	format "channel id: % mat name: %\n" m.effect_id m.name
	appendifunique usedIds m.effect_id
)
usedIds

-- appliquer les ids de materiaux en evitant les ids deja attribu�es
j = 0
for i = 1 to (matAr.count + j) do
(
	if matAr[i].effectsChannel != 0 then
	(
		res = finditem usedIds i
		format "deja assign: %, %, %\n" i matAr[i].name matAr[i].effectsChannel
	)
	else
	(
		format "assign: %, %\n" i matAr[i].name
	)
)

-- pour chaque chaque id de materiau cr�er un couche vray object selected
-- ajouter la couche vrayMtlID
	-- setter sur filtering et color
rem =MaxOps.GetCurRenderElementMgr ()
sceneMat = getclassinstances vrayMtl target: scenematerials
for m in sceneMat do
(
	if m.effect_id > 0 then
	(
		format "channel id: % mat name: %\n" m.effect_id m.name
		vrObjSelElt = VRayObjectSelect elementName: ("idMat_" + m.name) mode: 1 object_id: m.effect_id  use_material_id: true consider_for_antialiasing: true
		rem.AddRenderElement vrObjSelElt
	)
)

-- retourner les passes VRayObjectSelect du render element pour les supprimer
rem =MaxOps.GetCurRenderElementMgr ()
eltsNum = rem.NumRenderElements()
for i = 0 to (eltsNum - 1) do
(
	elt = rem.GetRenderElement i
	if iskindof elt VRayObjectSelect then
	(
		if elt.use_material_id then
		(
			format "%\n"	(rem.GetRenderElement i).elementName
		)
	)
)




