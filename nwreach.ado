capture program drop nwreach
program nwreach
	syntax [anything(name=reachnet)], [ name(string) vars(string) xvars symoff noreplace]
	_nwsyntax `reachnet', name(reachnet)

	// Generate valid name and vars
	if "`name'" == "" {
		local name "reach"
	}
	if "`stub'" == "" {
		local stub "_reach"
	}

	if "`replace'" != "noreplace" {
		capture nwdrop reach
	}

	nwvalidate `name'
	local reachname = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(`stub')
		local reachvars "$validvars"
	}
	else {
		local reachvars "`vars'"
	}	
	
	nwgeodesic `reachnet', name(`reachname') vars(`reachvars') unconnected(0) `xvars' `symoff'
	nwreplace `reachname' = 1 if `reachname' >= 0
	nwname `reachname', newdirected(true)
end
