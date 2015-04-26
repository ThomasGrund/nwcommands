capture program drop nwsimilar
program nwsimilar
	syntax [anything(name=netname)] [, type(string) name(string) mode(string) xvars]
	_nwsyntax `netname'
	
	if "`mode'" == "" {
		local mode = "both"
	}
	if "`type'" == "" {
		local type = "pearson"
	}

	_opts_oneof "pearson matches jaccard hamming crossproduct" "type" "`type'" 6556
	_opts_oneof "incoming outgoing both" "mode" "`mode'" 6556
	
	if "`name'" == "" {
		local name = "_similar"
	}

	nwvalidate `name'
	local name = "`r(validname)'"

	local dtype = 0
	if "`mode'" == "incoming" {
		local dtype = 1
	}
	if "`mode'" == "outgoing" {
		local dtype = 2
	}
	
	nwtomatafast `netname'

	if "`type'" == "pearson" {
		qui nwcorrelate `netname', name(`name')
	}	
	if "`type'" == "matches" {
		nwset, mat(matches_similarity(`r(mata)', `dtype')) name(`name')
	}
	if "`type'" == "jaccard" {
		nwset, mat(jaccard_similarity(`r(mata)', `dtype')) name(`name')
	}	
	if "`type'" == "hamming" {
		nwset, mat(hamming_similarity(`r(mata)', `dtype')) name(`name')
	}
	if "`type'" == "crossproduct" {
		nwset, mat(hamming_similarity(`r(mata)', `dtype')) name(`name')
	}	
	if "`xvars'" == "" {
		nwload `name'
	}
end

capture mata: mata drop matches_similarity()
mata:
real matrix matches_similarity(real matrix net,real scalar dtype){
	S = J(rows(net), cols(net), 0)
	for(i = 1; i<= rows(S); i++){
		for(j = 1; j<= cols(S); j++){
			i_outvec = net[i,.]
			i_invec = net[.,i]	
			j_outvec = net[j,.]
			j_invec = net[.,j]
			i_outvec[i] = 0
			i_outvec[j] = 0
			i_invec[i] = 0
			i_invec[j] = 0
			j_outvec[i] = 0
			j_outvec[j] = 0
			j_invec[i] = 0
			j_invec[j] = 0	
			
			i_outvec = (i_outvec :!= 0)
			j_outvec = (j_outvec :!= 0)
			i_invec = (i_invec :!= 0)
			j_invec = (j_invec :!= 0)
			
			if (dtype == 0 ) {
				S[i,j] = (sum(i_outvec :== j_outvec) + sum(i_invec :== j_invec) - 4) / ((cols(i_outvec) - 2) + (rows(i_invec) - 2))
			}
			if (dtype == 1 ) {
				S[i,j] = (sum(i_invec :== j_invec) - 2) / (cols(i_outvec) - 2) 
			}
			if (dtype == 2 ) {
				S[i,j] = (sum(i_outvec :== j_outvec) - 2) / (rows(i_invec) - 2)
			}
		}
	}
	return(S)
}
end

capture mata: mata drop jaccard_similarity()
mata:
real matrix jaccard_similarity(real matrix net,real scalar dtype){
	S = J(rows(net), cols(net), 0)
	for(i = 1; i<= rows(S); i++){
		for(j = 1; j<= cols(S); j++){
			i_outvec = net[i,.]
			i_invec = net[.,i]	
			j_outvec = net[j,.]
			j_invec = net[.,j]
			i_outvec[i] = 0
			i_outvec[j] = 0
			i_invec[i] = 0
			i_invec[j] = 0
			j_outvec[i] = 0
			j_outvec[j] = 0
			j_invec[i] = 0
			j_invec[j] = 0	
			
			i_outvec = (i_outvec :!= 0)
			j_outvec = (j_outvec :!= 0)
			i_invec = (i_invec :!= 0)
			j_invec = (j_invec :!= 0)
			
			if (dtype == 0 ) {
				S[i,j] = (sum((i_outvec :== j_outvec) :* (i_outvec :!= 0)) + sum((i_invec :== j_invec) :* (i_invec :!= 0))) / ((sum(i_outvec:!=0)) + (sum(i_invec:!=0)))
			}
			if (dtype == 1 ) {
				S[i,j] = (sum((i_invec :== j_invec) :* (i_invec:!=0))) / (sum((i_invec :+ j_invec) :!=0))
			}
			if (dtype == 2 ) {
					S[i,j] = (sum((i_outvec :== j_outvec) :* (i_outvec:!=0))) / (sum((i_outvec :+ j_outvec):!=0))
			}
		}
	}
	return(S)
}
end


capture mata: mata drop hamming_similarity()
mata:
real matrix hamming_similarity(real matrix net,real scalar dtype){
	S = J(rows(net), cols(net), 0)
	for(i = 1; i<= rows(S); i++){
		for(j = 1; j<= cols(S); j++){
			i_outvec = net[i,.]
			i_invec = net[.,i]	
			j_outvec = net[j,.]
			j_invec = net[.,j]
			i_outvec[i] = 0
			i_outvec[j] = 0
			i_invec[i] = 0
			i_invec[j] = 0
			j_outvec[i] = 0
			j_outvec[j] = 0
			j_invec[i] = 0
			j_invec[j] = 0	
			
			i_outvec = (i_outvec :!= 0)
			j_outvec = (j_outvec :!= 0)
			i_invec = (i_invec :!= 0)
			j_invec = (j_invec :!= 0)
			
			if (dtype == 0 ) {
				S[i,j] = (sum(i_outvec :== j_outvec) + sum(i_invec :== j_invec))
			}
			if (dtype == 1 ) {
				S[i,j] = (sum(i_invec :== j_invec))
			}
			if (dtype == 2 ) {
				S[i,j] = (sum(i_outvec :== j_outvec))
			}
		}
	}
	return(S)
}
end


capture mata: mata drop crossproduct_similarity()
mata:
real matrix crossproduct_similarity(real matrix net,real scalar dtype){
	S = J(rows(net), cols(net), 0)
	for(i = 1; i<= rows(S); i++){
		for(j = 1; j<= cols(S); j++){
			i_outvec = net[i,.]
			i_invec = net[.,i]	
			j_outvec = net[j,.]
			j_invec = net[.,j]
			i_outvec[i] = 0
			i_outvec[j] = 0
			i_invec[i] = 0
			i_invec[j] = 0
			j_outvec[i] = 0
			j_outvec[j] = 0
			j_invec[i] = 0
			j_invec[j] = 0	
			
			i_outvec = (i_outvec :!= 0)
			j_outvec = (j_outvec :!= 0)
			i_invec = (i_invec :!= 0)
			j_invec = (j_invec :!= 0)
			
			if (dtype == 0 ) {
				S[i,j] = (sum(i_outvec :* j_outvec) + sum(i_invec :* j_invec))
			}
			if (dtype == 1 ) {
				S[i,j] = (sum(i_invec :* j_invec))
			}
			if (dtype == 2 ) {
				S[i,j] = (sum(i_outvec :* j_outvec))
			}
		}
	}
	return(S)
}
end




