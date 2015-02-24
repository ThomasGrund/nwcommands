capture program drop nwequiv
program nwequiv
	syntax [anything(name=netname)] [, type(string) iter(integer 3) generate(string) mode(string) *]
	
	if "`generate'" == "" {
		local generate "_eqvclass"
	}

	local name = "equivalence"
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
	if ("`type'" == "regular"){
		mata: S = regularEquivalence(onenet, `iter')
		capture nwdrop _regEquiv
		nwset, mat(S) name(`name')
		mata: S
		mata: S = (S:== 1)
	}
	
	nwset, mat(S) name(__equiv)
	capture drop `generate'
	tempvar comp isol
	qui nwgen `isol' = isolates(`netname')
	qui nwcomponents __equiv, generate(`comp')
	qui replace `comp' = -1 if `isol' == 1
	qui egen `generate' = group(`comp')
	label variable `generate' "`generate'"
	tab `generate', `options'
	
	capture mata: mata drop S
	capture mata: mata drop onenet
	capture nwdrop __equiv

end


capture mata: mata drop structuralEquivalence()
capture mata: mata drop distanceEquivalence()
capture mata: mata drop getDistribution()
capture mata: mata drop getSimilarity()
capture mata: mata drop getMatch()
capture mata: mata drop regularEquivalence()

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

real matrix regularEquivalence(real matrix X, scalar iter) {
	Sstart = J(rows(X), cols(X), 1)
	for (i = 1 ; i <= iter; i++) {
		Sstart = getSimilarity(X, Sstart)
	}
	return(Sstart)
}

mata:
real matrix getSimilarity(real matrix X,real matrix S) {
	S_new = S
	for(i=1; i<= rows(X);i++){
		for(j=1;j<= rows(X);j++){
			S_new[i,j] = getMatch(X,S_new,i,j)
		}
	}
	return(S_new)
}


real scalar getMatch(X,S,a,e) {
	
	points = 0
	points_max = 0 
	
	nodes = rows(X)
	temp = (1::nodes)
	
	a_outties = (editvalue((X[a,.] - X[.,a]'),-1,0))'
	a_outties
	a_out = select(temp, a_outties)
	a_inties = (editvalue((X[.,a]' - X[a,.]),-1,0))'
	a_in = select(temp, a_inties)
	a_mutualties = (editvalue((X[a,.] + X[.,a]'),1,0))' :== 2
	a_mutual = select(temp, a_mutualties)

	e_outties = (editvalue((X[e,.] - X[.,e]'),-1,0))'
	e_out = select(temp, e_outties)
	e_inties = (editvalue((X[.,e]' - X[e,.]),-1,0))'
	e_in = select(temp, e_inties)
	e_mutualties = (editvalue((X[e,.] + X[.,e]'),1,0))' :== 2
	e_mutual = select(temp, e_mutualties)	
	
	/////////
	//	A's PERSPECTIVE
	/////////
	
	// go through all out neighbors of a
	for (i = 1 ; i <= rows(a_out); i++) {
		bestmatch = 0
		ii = a_out[i]
		// look for a best match among e's neighbors and calculate points
		for (j = 1; j<= rows(e_out); j++) {
			jj = e_out[j]
			if (S[ii,jj] > bestmatch) {
				bestmatch = S[ii,jj]
			}
		}
		points = points + bestmatch
	}
	// go through all in neighbors of a
	for (i = 1 ; i <= rows(a_in); i++) {
		ii = a_in[i]
		bestmatch = 0
		// look for a best match among e's neighbors and calculate points
		for (j = 1; j<= rows(e_in); j++) {
			jj = e_in[j]
			if (S[ii,jj] > bestmatch) {
				bestmatch = S[ii,jj]
			}
		}
		points = points + bestmatch
	}
	// go through all mutual neighbors of a
	for (i = 1 ; i <= rows(a_mutual); i++) {		
		ii = a_mutual[i]
		bestmatch = 0
		// look for a best match among e's neighbors and calculate points
		for (j = 1; j<= rows(e_mutual); j++) {
			jj = e_mutual[j]
			if (S[ii,jj] > bestmatch) {
				bestmatch = 2 * S[ii,jj]
			}
		}
		//WILDCARD find best match among e' in /out neighbors
		if (bestmatch == 0) {
			for (j = 1; j<= rows(e_in); j++) {
				jj = e_in[j]
				if (S[ii,jj] > bestmatch) {
					bestmatch = S[ii,jj]
				}
			}
			for (j = 1; j<= rows(e_out); j++) {
				jj = e_out[j]
				if (S[ii,jj] > bestmatch) {
					bestmatch = S[ii,jj]
				}
			}
		}
		
		points = points + bestmatch
	}
	
	/////////
	//	E's PERSPECTIE
	/////////
	
	// go through all out neighbors of e
	for (i = 1 ; i <= rows(e_out); i++) {
		bestmatch = 0
		ii = e_out[i]
		// look for a best match among e's neighbors and calculate points
		for (j = 1; j<= rows(a_out); j++) {
			jj = a_out[j]
			if (S[ii,jj] > bestmatch) {
				bestmatch = S[ii,jj]
			}
		}
		points = points + bestmatch
	}
	// go through all in neighbors of e
	for (i = 1 ; i <= rows(e_in); i++) {
		bestmatch = 0
		ii = e_in[i]
		// look for a best match among e's neighbors and calculate points
		for (j = 1; j<= rows(a_in); j++) {
			jj = a_in[j]
			if (S[ii,jj] > bestmatch) {
				bestmatch = S[ii,jj]
			}
		}
		points = points + bestmatch
	}
	// go through all mutual neighbors of e
	for (i = 1 ; i <= rows(e_mutual); i++) {
		bestmatch = 0
		ii = e_mutual[i]
		// look for a best match among e's neighbors and calculate points
		for (j = 1; j<= rows(a_mutual); j++) {
			jj = a_mutual[j]
			if (S[ii,jj] > bestmatch) {
				bestmatch = 2 * S[ii,jj]
			}
		}
		//WILDCARD find best match among a' in /out neighbors
		if (bestmatch == 0) {
			for (j = 1; j<= rows(a_in); j++) {
				jj = a_in[j]
				if (S[ii,jj] > bestmatch) {
					bestmatch = S[ii,jj]
				}
			}
			for (j = 1; j<= rows(a_out); j++) {
				jj = a_out[j]
				if (S[ii,jj] > bestmatch) {
					bestmatch = S[ii,jj]
				}
			}
		}
		points = points + bestmatch
	}

	points_max = rows(a_out) + rows(a_in) + 2 * rows(a_mutual) + rows(e_out) + rows(e_in) + 2 * rows(e_mutual)
	return(points /  points_max)
}
end


