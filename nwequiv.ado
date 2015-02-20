capture program drop nwequiv
program nwequiv
	syntax [anything(name=netname)] [, type(string) generate(string) mode(string) *]
	
	if "`generate'" == "" {
		local generate "_eqvclass"
	}

	local name = "equivalent"
	nwvalidate `name'
	local name = r(validname)
		
	if "`type'" == "" {
		local type = "structural"
	}
	if "`mode'" == "" {
		local mode = "both"
	}
	_nwsyntax `netname'
	
	nwtomata `netname', mat(onenet)
	if "`type'" == "structural" {
		if "`mode'" == "outgoing" {
			mata: S = structuralEquivalence(onenet, 1)
		}
		if "`mode'" == "incoming" {
			mata: S = structuralEquivalence(onenet, 2)
		}
		if "`mode'" == "both" {
			mata: S = structuralEquivalence(onenet, 1) + structuralEquivalence(onenet, 2)
			mata: S = (S:==2)
		}
	}
	if ("`type'" == "automorphicstrict") {
		capture nwdrop temp_geodesic
		qui nwgeodesic `netname', name(__temp_geodesic) nosym
		nwtomata __temp_geodesic, mat(onenet)
		if "`mode'" == "outgoing" {
			mata: S = structuralEquivalence(onenet, 1)
		}
		if "`mode'" == "incoming" {
			mata: S = structuralEquivalence(onenet, 2)
		}
		if "`mode'" == "both" {
			mata: S = structuralEquivalence(onenet, 1) + structuralEquivalence(onenet, 2)
			mata: S = (S:==2)
		}
		nwdrop __temp_geodesic
	}
	if ("`type'" == "automorphic") {
		capture nwdrop temp_geodesic
		qui nwgeodesic `netname', name(__temp_geodesic) nosym
		nwtomata __temp_geodesic, mat(onenet)
		if "`mode'" == "outgoing" {
			mata: S = distanceEquivalence(onenet, 1)
		}
		if "`mode'" == "incoming" {
			mata: S = distanceEquivalence(onenet, 2)
		}
		if "`mode'" == "both" {
			mata: S = distanceEquivalence(onenet, 1) + distanceEquivalence(onenet, 2)
			mata: S = (S:==2)
		}
		nwdrop __temp_geodesic
	}
	
	nwset, mat(S) name(`name')
	capture drop `generate'
	tempvar comp isol
	qui nwgen `isol' = isolates(`netname')
	qui nwcomponents `name', generate(`comp')
	qui replace `comp' = -1 if `isol' == 1
	qui egen `generate' = group(`comp')
	label variable `generate' "`generate'"
	tab `generate', `options'
	
	capture mata: mata drop S
	capture mata: mata drop onenet
	capture nwdrop `name'

end


capture mata: mata drop structuralEquivalence()
capture mata: mata drop distanceEquivalence()
capture mata: mata drop getDistribution()

mata:
real matrix structuralEquivalence(real matrix net, scalar mode) {
	nodes = rows(net)
	S = J(nodes, nodes, 0)
	for (i = 1; i<= nodes; i++) {
		if (mode == 1) {
			i_ties = net[i,.]
		}
		if (mode == 2) {
			i_ties = net[.,i]
		}
		for (j = 1; j<= nodes; j++) {
			if (mode == 1) {
				j_ties = net[j,.]
			}
			if (mode == 2) {
				j_ties = net[.,j]
			}
			
			
			if (i != j){
				ix_ties = i_ties
				ix_ties[i] = 0
				ix_ties[j] = 0				
				jx_ties = j_ties
				jx_ties[i] = 0
				jx_ties[j] = 0
				if (ix_ties == jx_ties){
					S[i,j] = 1
				}
			}
		}
	}
	return(S)
}

real matrix distanceEquivalence(real matrix net, scalar mode) {
	nodes = rows(net)
	S = J(nodes, nodes, 0)
	for (i = 1; i<= nodes; i++) {
		if (mode == 1) {
			i_ties = getDistribution(net[i,.],nodes)
		}
		if (mode == 2) {
			i_ties =  getDistribution(net[.,i]',nodes)
		}
		for (j = 1; j<= nodes; j++) {
			if (mode == 1) {
				j_ties = getDistribution(net[j,.],nodes)
			}
			if (mode == 2) {
				j_ties = getDistribution(net[.,j]',nodes)
			}
			
			
			if (i != j){
				ix_ties = i_ties
				ix_ties[i] = 0
				ix_ties[j] = 0				
				jx_ties = j_ties
				jx_ties[i] = 0
				jx_ties[j] = 0
				if (ix_ties == jx_ties){
					S[i,j] = 1
				}
			}
		}
	}
	return(S)
}

real matrix getDistribution(real matrix X, scalar max){
	if (max == 0) {
		max = cols(X)
	}
	
	result = J(1,max,0)
	for(i = 1; i <=max; i++){
		result[1,i] = sum(X:== i)
	}
	return(result)
}
end

