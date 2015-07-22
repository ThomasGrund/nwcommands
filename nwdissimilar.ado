capture program drop nwdissimilar
program nwdissimilar
	syntax [anything(name=netname)] [, type(string) labs(passthru) vars(passthru) name(string) context(string) xvars]
	_nwsyntax `netname'
	
	if "`context'" == "" {
		local context = "both"
	}
	if "`type'" == "" {
		local type = "euclidean"
	}

	_opts_oneof "euclidean manhatten nonmatches jaccard hamming" "type" "`type'" 6556
	_opts_oneof "incoming outgoing both" "context" "`context'" 6556
	
	if "`name'" == "" {
		local name = "_dissimilar"
	}

	nwvalidate `name'
	local name = "`r(validname)'"
	
	local dtype = 0
	if "`context'" == "incoming" {
		local dtype = 1
	}
	if "`context'" == "outgoing" {
		local dtype = 2
	}
	
	nwtomatafast `netname'
	if "`type'" == "euclidean" {
		nwset, mat(euclidean_dissimilarity(`r(mata)', `dtype')) name(`name') `labs' `vars'
	}
	if "`type'" == "manhatten" {
		nwset, mat(manhatten_dissimilarity(`r(mata)', `dtype')) name(`name') `labs' `vars'
	}	
	if "`type'" == "nonmatches" {
		nwset, mat(matches_dissimilarity(`r(mata)', `dtype')) name(`name') `labs' `vars'
	}
	if "`type'" == "jaccard" {
		nwset, mat(jaccard_dissimilarity(`r(mata)', `dtype')) name(`name') `labs' `vars'
	}	
	if "`type'" == "hamming" {
		nwset, mat(hamming_dissimilarity(`r(mata)', `dtype')) name(`name') `labs' `vars'
	}	
	if "`xvars'" == "" {
		nwload `name'
	}
end

capture mata mata drop euclidean_dissimilarity()
capture mata mata drop manhatten_dissimilarity()
capture mata mata drop matches_dissimilarity()
capture mata mata drop jaccard_dissimilarity()
capture mata mata drop hamming_dissimilarity()

mata:
real matrix euclidean_dissimilarity(real matrix net, real scalar dtype){
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

			if (dtype == 0 ) {
				S[i,j] = sqrt(sum((i_outvec :- j_outvec):^2)+ sum((i_invec :- j_invec):^2))
			}
			if (dtype == 1 ) {
				S[i,j] = sqrt(sum((i_invec :- j_invec):^2))
			}
			if (dtype == 2) {
				S[i,j] = sqrt(sum((i_outvec :- j_outvec):^2))
			}
		}
	}
	return(S)
}

real matrix manhatten_dissimilarity(real matrix net ,real scalar dtype){
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
			if (dtype == 0 ) {
				S[i,j] = (sum(abs(i_outvec :- j_outvec))+ sum(abs(i_invec :- j_invec)))
			}
			if (dtype == 1 ) {
				S[i,j] = (sum(abs(i_invec :- j_invec)))
			}
			if (dtype == 2 ) {
				S[i,j] = (sum(abs(i_outvec :- j_outvec)))
			}
		}
	}
	return(S)
}

real matrix matches_dissimilarity(real matrix net,real scalar dtype){
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
				S[i,j] = 1 - (sum(i_outvec :== j_outvec) + sum(i_invec :== j_invec) - 4) / ((cols(i_outvec) - 2) + (rows(i_invec) - 2))
			}
			if (dtype == 1 ) {
				S[i,j] = 1 - (sum(i_invec :== j_invec) - 2) / (cols(i_outvec) - 2) 
			}
			if (dtype == 2 ) {
				S[i,j] = 1 - (sum(i_outvec :== j_outvec) - 2) / (rows(i_invec) - 2)
			}
		}
	}
	return(S)
}

real matrix jaccard_dissimilarity(real matrix net,real scalar dtype){
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
				S[i,j] = 1 - (sum((i_outvec :== j_outvec) :* (i_outvec :!= 0)) + sum((i_invec :== j_invec) :* (i_invec :!= 0))) / ((sum(i_outvec:!=0)) + (sum(i_invec:!=0)))
			}
			if (dtype == 1 ) {
				S[i,j] = 1 - (sum((i_invec :== j_invec) :* (i_invec:!=0))) / (sum((i_invec :+ j_invec) :!=0))
			}
			if (dtype == 2 ) {
					S[i,j] = 1 - (sum((i_outvec :== j_outvec) :* (i_outvec:!=0))) / (sum((i_outvec :+ j_outvec):!=0))
			}
		}
	}
	return(S)
}

real matrix hamming_dissimilarity(real matrix net,real scalar dtype){
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
				S[i,j] = (sum(i_outvec :!= j_outvec) + sum(i_invec :!= j_invec))
			}
			if (dtype == 1 ) {
				S[i,j] = (sum(i_invec :!= j_invec))
			}
			if (dtype == 2 ) {
				S[i,j] = (sum(i_outvec :!= j_outvec))
			}
		}
	}
	return(S)
}
end




