capture program drop nwdissimilar
program nwdissimilar
	syntax [anything(name=netname)] [, name(string)]
	_nwsyntax `netname'
	
	if "`name'" == "" {
		local name = "_dissimilar"
	}
	
	nwtomatafast `netname'
	nwset, mat(dissimilarity(`r(mata)')) name("_dissimilar")
	
end

capture mata: mata drop dissimilarity()
mata:

real matrix dissimilarity(real matrix net){

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
			S[i,j] = sqrt(sum((i_outvec :- j_outvec):^2)+ sum((i_invec :- j_invec):^2))
		}
	}
	return(S)
}
end

