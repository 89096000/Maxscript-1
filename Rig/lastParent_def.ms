
fn lastParent sel =
(
	undo on
	(
-- 		format "parenting start\n" -- to: log
		local daddy = sel[sel.count]
		
		for i = 1 to (sel.count - 1) do
		(
			
			local parentable = true
			local parentInSel = false
			-- test parent dans la selection
			for j = 1 to (sel.count - 1) do
			(
-- 				tmpParent = sel[j].parent
				if isvalidnode  sel[i].parent and i != j then
				(
-- 					print "check1"
-- 					format "i: %, parent: % ,j: %\n" sel[i].name sel[i].parent.name sel[j].name
					if sel[i].parent == sel[j] then 
					(
-- 						print "check2"
						parentable = false
						parentInSel = true
						exit
					)
				)
				else if  i != j then 
				(
-- 					print "check3"
-- 					format "i: %, parent: % ,j: %\n" sel[i].name sel[i].parent sel[j].name
					exit
				)
				else
				(
-- 					print "check4"
-- 					format "i: %, parent: % ,j: %\n" sel[i].name sel[i].parent sel[j].name
				)
				
-- 				if parentable ==  false then 
			)
			
			-- exclusion des railclone
-- 			if classof sel[i] == RailClone_Pro then  parentable = false
			
			if not parentInSel then
			(
				-- test appartenance � un groupe 
				if isGroupMember sel[i] and not isGroupHead sel[i]  then parentable = false
			)
			
			-- prent
-- 			format "parentInSel: % parentable: %\n" parentInSel parentable
			try
			(
				if parentable then 
				(
-- 					format "i: %, groupHead: %, groupmember: %, parent: %, parentable:%, parentinsel: % \n" sel[i].name (isGroupHead sel[i])  (isGroupMember sel[i]) sel[i].parent parentable parentInSel
					sel[i].parent = daddy
				)
				else (/*format "no parenting\n"*/)
			)
			catch(format "FAIL: % , ERROR: %\n"  sel[i].name (getcurrentexception()))
		)
	)
)

-- sel = selection as array
-- lastParent sel
