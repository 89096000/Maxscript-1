

--appeler un controller de poids. ne peut �tre appeler qu'une fois qu'on l'a d�fini comme controleur b�zier ou autre
 $box001.pos.controller.weight[1].controller
 
 --appeler controller de position: suivre l'arbre de hi�rarchie en rempla�ant les espaces par des underscore. si on renomme les controlleur les appeler par leurs nouveaux noms.
 $box001.pos.controller.pos_xyz_A.controller.x_position.controller
 
 --appeler une valeur: rajouter ".value" d�rri�re le controller
   $box001.pos.controller.pos_xyz_A.controller.x_position.controller.value
   

   --en fait  pos.x  d�signe la position de l'objet en x et pos.controller.x_position.controller �a d�signe le controleur de position x.
