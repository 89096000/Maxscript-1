-- select in scene bone selected in skin modifier
m = modPanel.getCurrentObject() 
if classof m == skin then
(
	boneId = skinOps.GetSelectedBone m
	res = skinOps.GetBoneName m boneId 0
	select (getnodebyname res)
)
else(print "fail")


-- select vertex by bone selected in skin modifier
fn selVertByBones =
(
	m = modPanel.getCurrentObject() 
	if classof m == skin then
	(
		-- collecter le bone selectionner
		boneId = skinOps.GetSelectedBone m
		-- recuperer le nombre vertex de la mesh
		vxCount = skinOps.GetNumberVertices m

		goodVxAr = #()
		for i = 1 to vxCount do
		(
		-- pour chaque vertex
			-- trouver le nombre d'influence
			maxInf = skinOps.GetVertexWeightCount m i
			
			for id = 1 to maxinf do
			(
				res = skinOps.GetVertexWeightBoneID m i id
				-- si le bone selectionner est dans les influence du vertex collecter le numero du vertex
				if res == boneId do append goodVxAr i
			)
		)
		-- selectionner les vertex collect�s
		skinOps.SelectVertices m goodVxAr
	)
	else(print "fail")
)
selVertByBones()


-- keep selection

	
/* WEIGHT MULTPLICATION */
-- collecte du skin selectionn�

m = modPanel.getCurrentObject()

-- lister les bones
skinMaxBones = skinOps.GetNumberBones m

-- retourner une selection de vertex
fn getSkinVertSel m =
(
	local vxSelAr
	vxCount = skinOps.GetNumberVertices m
	vxSelAr = for i = 1 to vxcount where skinops.IsVertexSelected m i == 1 collect i
	vxSelAr
)


-- collecter les poids sur une selection de vertex
fn collectVxWt vxSelAr m =
(
	local vxWtAr = #()
	local bnList
	local wtList
	
	for vx in vxSelAr do
	(
	-- 	vx = 21
		bnList = #()
		wtList = #()
		vxMaxBones = skinOps.GetVertexWeightCount m vx
		
		for i = 1 to vxMaxBones do
		(
			append bnList (skinOps.GetVertexWeightBoneID m vx i)
			append wtList (skinOps.GetVertexWeight m vx i)
		)
		append vxWtAr #(bnList, wtList)
	)
	format "vxWtAr:%\n" vxWtAr
	vxWtAr
)

-- calculer une moyene de poids sur les poids d'une selection de vertex
-- Methode 2
vxSelAr = getSkinVertSel m
vxWtAr = collectVxWt vxSelAr m


-- cr�er un array du nombre de bone
bnAr = for bn = 1 to skinMaxBones collect 0.0
-- pour chaque influence trouv�e sur chaque vertex ajout� l'influences
for vxVal in vxWtAr do
(
	format "vxVal: % \n" vxVal
	-- calcul de l'array
	for i = 1 to vxVal[1].count do
	(
		id = vxVal[1][i]
-- 		format "vxVal[1][i]:%,  vxVal[2][i]: %, bnAr[vxVal[1][i]]: %\n" vxVal[1][i] vxVal[2][i] bnAr[id]
		
		bnAr[id] = bnAr[id] + vxVal[2][i]
	)
)
format "vertex value 2: % \n" bnAr
-- moyenne sur l'array
bnArAdd = for val in bnAr collect val/vxSelAr.count

-- les array de poids ont deux formes, une avec deux array(pour le replace) et une avec un seul array(pour les calculs)

-- Mix value
vxDestSel = getSkinVertSel m
vxWtDestAr = collectVxWt vxDestSel m
-- vxWtSrc = #(bnListMedium, wtListMedium)


fn calcToApplyForm bnAr =
(
	-- lorsqu'une valeur de l'array est sup�rieure � 0: la collect� et la diviser par le nombre de vertex selectionn�s
	bnListMedium = #()
	wtListMedium = #()
	for bn = 1 to bnAr.count where bnAr[bn] != 0 do
	(
	-- calculer une moyene de poids sur les poids d'une selection de vertex
		format "bn(id): %, bnAr[bn](weight): %\n" bn bnAr[bn]
		append bnListMedium bn
		append wtListMedium (bnAr[bn]/vxSelAr.count)
	)
	#(bnListMedium, wtListMedium)
)

-- pour chaque vertex de la destination
for vxVal in vxWtDestAr do
(
	bnAr = for bn = 1 to skinMaxBones collect 0
	-- deployer les valeur initiale
	for i = 1 to vxVal[1].count do
	(
		id = vxVal[1][i]		
		bnAr[id] = vxVal[2][i]
	)	
	format "vertex value dest: % \n" bnAr
	
	/*
	bnArAdd = for bn = 1 to skinMaxBones collect 0
		
	-- deployer les valeur � ajouter
	for i =  1 to vxWtSrc[1].count do
	(
		id = vxWtSrc[1][i]
		bnArAdd[id] = vxWtSrc[2][i]
	)
	format "vertex value added: % \n" bnArAdd
	*/
	
	-- mix�
	multi1 = 0.5
	multi2 = 1 - multi1
	for i = 1 to bnAr.count do
	(
		bnAr[i] = bnAr[i]*multi1 + bnArAdd[i]*multi2
	)
	format "vertex value mixed: % \n" bnAr
	
	bnListMedium = #()
	wtListMedium = #()
	for bn = 1 to bnAr.count where bnAr[bn] != 0 do
	(
	-- calculer une moyene de poids sur les poids d'une selection de vertex
		format "bn(id): %, bnAr[bn](weight): %\n" bn bnAr[bn]
		append bnListMedium bn
		append wtListMedium (bnAr[bn]/vxSelAr.count)
	)
-- 	#(bnListMedium, wtListMedium)
	
	format "vertex: %, bones:%, weight: % \n\n" vx bnListMedium wtListMedium 
	skinOps.ReplaceVertexWeights m vx bnListMedium wtListMedium
	
	-- retourner deux array applicable
)



-- calcul de la moyenne et mise en forme des array

/*
-- Methode 1
bnListMedium = #()
wtListMedium = #()
for i = 1 to skinMaxBones do
(
	boneWt = #()
	-- collecte des poids d'un bone sur une selection de vertex
	for j = 1 to vxWtAr.count do 
	(
-- 		format "vertexValue: bones: %, values: %\n" o[1] o[2]
		val = undefined
		
		res = finditem vxWtAr[j][1] i
		if res > 0 then val = vxWtAr[j][2][res]
			
		if val == undefined then
		(
-- 			format "bones: %, vertexArray: %, no value \n" i j
		)
		else 
		(
-- 			format "bones: %, vertexArray: %, value: % \n"  i j val
			append boneWt val
		)
	)
-- 	format "bone: %, count: %, values: % \n"  i boneWt.count boneWt
	
	-- calculer la moyenne des poids du bone
	if boneWt.count > 0 then
	(
		sum = 0
		for wt in boneWt do sum += wt
		medVal = sum/boneWt.count
		format "bone: %, medium: %\n"  i medVal
		append bnListMedium i
		append wtListMedium medVal
	)
)
medVertex = #(bnListMedium, wtListMedium)
*/


-- copier/coller les valeurs d'un vertex sur d'autre

-- ponderer la moyenne

-- donner un coup de marteau sur un vertex par rapport � ces voisin
	-- selectionner un vertex
	-- grossir la selection
	-- r�cup�rer les valeur des vertex autour
	-- calculer la moyenne de ces valeur
	-- affecter la valeur aux vertex selectionner

-- ecrire les poids d'un vertex en code




/* WEIGHT ADDITION */
-- ajouter du poids � un bones sur une selection de vertex
	-- selectionner un ou plusieurs vertex
vxSelAr = getSkinVertSel m

-- collect unlocked bones
skinMaxBones = skinOps.GetNumberBones m
unLockedBoneList = for i = 1 to skinMaxBones collect i

-- selectionner un bones
majoredBone = skinOps.GetSelectedBone m
format "bone majored id: %\n" majoredBone
-- pour chaque vertex:
wtAdd = 0.01

for vx in vxSelAr do
(
-- 	vx = 21
	
	/* Collecte du set bones et de poids */
	-- collecter la liste de bones et la liste de poids correspondants
	vxMaxBones = skinOps.GetVertexWeightCount m vx
	bnList = #()
	wtList = #()
	
	for i = 1 to vxMaxBones do
	(
		append bnList (skinOps.GetVertexWeightBoneID m vx i)
		append wtList (skinOps.GetVertexWeight m vx i)
	)
	#(bnList, wtList)
	format "vertex: %, bones: %, weights: % \n" vx bnList wtList


	/* Check du set sur lequel travailler*/
	boneMajoredUnlocked = False
	-- tester si le bone � majorer est delock�
	res = finditem unLockedBoneList majoredBone
	if res > 0 then boneMajoredUnlocked = true
	
	-- tester si le bone majorer est d�ja une influence du vertex
	mbiId = finditem bnList majoredBone
	majoredCorrect = False
	if mbiId > 0 then 
	(
		majoredCorrect = True
		format "bone majored: %, initial weight: %\n" bnList[mbiId] wtList[mbiId]
	)
	else
	(
		append bnList majoredBone
		append wtList 0
		mbiId = bnList.count
		majoredCorrect = true
		format "bone majored added : %, initial weight: %\n" bnList[mbiId] wtList[mbiId]
	)
	
	-- collecter les bones sur lesquels on enl�ve du poid
	minoredCorrect = False
	minoredBnList = #()
	minoredWtList = #()
	minoredBnIdList = #()
	for i = 1 to bnList.count do
	(
		if bnList[i] != majoredBone and (finditem unLockedBoneList bnList[i]) > 0 then
		(
			append minoredBnList bnList[i]
			append minoredWtList wtList[i]
			append minoredBnIdList i
		)
		if minoredBnList.count >= 1 then minoredCorrect = True
	)
	format "minored bones: % ,  initial weight: %\n" minoredBnList minoredWtList
	
	


	/* test du poids � ajouter */
	majoredBoneWt = wtList[mbiId]
		-- pr�voir que l'addition arrive � 0 ou � 1 sur le bone major�e et laisse un reste:
			-- permettre l'addition, soustraire le reste de l'influence � repartir sur les autres bones
	
	-- pr�voir que la compensation arrive � 0 ou � 1 sur un bone minor� et laisse un reste:
			-- r�partir ce reste sur les autre bones disponible
	
	
	-- majoration
	additionDone = False
	-- si le bone � majorer est correct et si les bone � minorer son correct
	if majoredCorrect == true and minoredCorrect == true  then 
	(
		-- tester si la valeur major�e est comprise entre 0 et 1
		if (wtList[mbiId] + wtAdd) > 0 and (wtList[mbiId] + wtAdd) < 1 then
		(
-- 			ADDITION
-- 			si le bone est pr�sent dans les influences, ajouter le poids
			format "vertex: %, bone majored: %, weight initial:% \n" vx majoredBone wtList[mbiId] 
			wtList[mbiId] += wtAdd
			
			format "vertex: %, bone majored: %, weight majored:% \n" vx majoredBone wtList[mbiId]
			
-- 			COMPENSATION
			minorWt = wtAdd / minoredBnList.count
			for id in minoredBnIdList do
			(
				wtList[id] -= minorWt
			)
			
			additionDone = True
		)
		else (format "vertex: %, bone: %, addition impossible, valeur butoir atteinte\n" vx majoredBone ) 
	)
	else (format "vertex: %, bone majored: %, bones minored: %, addition impossible\n" vx majoredBone minoredBnList ) 

	-- compensation
	if additionDone == True then 
	(
		format "vertex: %, bones:%, weight: % \n\n" vx bnList wtList 
		skinOps.ReplaceVertexWeights m vx bnList wtList
	)
	
			-- diviser le poids ajouter en autant de bones collecter
			-- retrancher le poids au poids des bones delock�s (repartition �gale)
			-- retrancher le poids au poids des bones delock�s (repartition proportionn�)
	
		-- enlever tout ce poids uniquement au vertex delock�s
)







-- locker/delocker une selection de bones pour appliquer des poids
	-- verifier si les bones du vertex selectionn� pour l'ajout sont lock�s ou non  

