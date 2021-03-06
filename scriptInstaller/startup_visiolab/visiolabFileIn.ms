/*
doc:
	-- ce fichier 
		- 1 - preload les fonctions necessaire � faire fonctionner les macros
		- 2 -  supprime les macros existantes
		- 3 -  installe le macros et les icones
	
	Le fichier est utilis� � la premi�re installation et � chaque ouverture de max

maj:
	x- loader une methode au startup qui retourne le root plutot que rappeler l'ini � chaque fois (getRoot)
	/- cr�er deux m�thodes g�n�rales pour enregistrer et charger les favoris
	/- cr�er un fichier dans le startup de max qui load les methodes souhait� (filein "lasparent.ms")
	x- pre load des script avant macro script:
		x- soit dans le fichier plugin soit ajouter une adresse dans les fichier user "pluginpaths": ajouter le chemin au plugin path

	/- d�placer ce script dans le dossier startup pour cr�er un update � chaque d�marrage:
		-- nettoyer les macroscripts existants dans le #maxdata
		-- nettoyer le dossier startup de "armadasfilein.ms"

		-- updater le root dans l'armadas script.ini
		-- updater les icons
		-- updater le pluginpath.ini

	-- mettre en place un systeme de versionning des script et ouvrir la derni�re version valide
	
	-- cr�er une table pour lister les versions de script � loader dans les macroscript
		-- permet de porposer une table wip/debug/published
		-- s'appuie sur le versionnement dans des dossiers
		-- propose de faire la bascule entre wip/debup/published
		--permet d'accorder des autorisations
		
	x- cr�er un script de reload (comment une reinstallation)
	-- sur le mode du reload propos� un switch entre wip/debug / publish
		-- est ce que la separation wip/debug/publish est necessaire? est ce que deux list de macros distintes (armadascript(wip) et visiolab(publish)) n'est pas plus pertinente (pas besoin de switch)?
	
	-- cr�er un menu visiolab automatiquement avec menuMan.getMainMenuBar
	
	-- tester les icone avant de les copier
		-- trouver comment forcer la copie
*/

fn getRoot =
(
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)

-- pre Load
filein ((getRoot ()) + "scriptInstaller/armadasScriptsPreLoad.ms")

-- load du fichier de macros
filein ((getRoot ()) + "scriptInstaller/visiolabMacrosList.ms")



