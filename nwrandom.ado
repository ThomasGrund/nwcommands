*! Date        : 23oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwrandom
program nwrandom
	syntax anything(name=nodes), [selfloop ntimes(integer 1) Census(numlist integer min=1 max=3) Density(string) Prob(string) labs(string) name(string) undirected xvars noreplace * ]
	unw_defs
	
	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "random"
	}

	if `ntimes' != 1 {
		di in smcl as txt "{p}"
		forvalues i = 1/`ntimes'{
			if mod(`i', 25) == 0 {
				di in smcl as txt "...`i'"
			}
			nwrandom `nodes', census(`census') name(`name'_`i') density(`density') prob(`prob') `selfloop' `xvars' `undirected' labs(`labs')
		}
		exit
	}
	
	tempname __nwnew
	
	if ("`prob'" != "") {
		mata: `__nwnew' = get_random_prob(`nodes', `prob', ("`undirected'" != ""), "`selfloop'" != "")
	}
	if ("`density'" != "") {
		mata: `__nwnew' = get_random_density(`nodes', `density', ("`undirected'" != ""), "`selfloop'" != "")
	}
	if "`census'" != "" {
		local mutual : word 1 of `census'
		local asym : word 2 of `census'
		if "`asym'" == "" {
			local asym = 0	
		}
		local total = `mutual' + `asym'	
		if `total' > `=((`nodes' * (`nodes'-1)) / 2)' {
			di "{err}Too manny dyads requested,"
			exit
		}
		mata: `__nwnew' = dyadcensusGenerator(`nodes', `mutual', `asym')
	
	}
	
	if ("`prob'"=="" & "`density'"=="" & "`census'" == ""){
		di "{err}either {it:prob}(), {it:density}() or {it:census()} missing"
		exit
	}

	mata: st_rclear()
	nwset, mat(`__nwnew') name(`randomname') labs(`labs') `undirected' `selfloop'

	if "`xvars'" == "" {
		nwload `randomname'
	}
	capture mata: mata drop `__nwnew'
end


capture mata: mata drop tiesGenerator()
capture mata: mata drop correctDiagonal()
capture mata: mata drop dyadcensusGenerator()
capture mata: mata drop get_random_prob()
capture mata: mata drop get_random_density()

mata:
real matrix get_random_prob(real scalar nodes, real scalar prob, real scalar undirected, real scalar selfloop){
	real matrix adj 
	
	adj = floor(uniform(nodes,nodes) :+ prob)
	if (undirected == 1) {
		_makesymmetric(adj)
	}
	if (selfloop == 0){
		_diag(adj,0)
	}
	return(adj)
}

real matrix get_random_density(real scalar nodes, real scalar density, real scalar undirected, real scalar selfloop){
	real scalar ties, n2, tiesdiag
	real matrix adj
	
	ties = floor((nodes * (nodes -(1 - selfloop)) * density))
	n2 = nodes * nodes
		
	if (undirected == 0){
		adj=(1::n2)
		_jumble(adj)
		adj=colshape(adj, nodes)
		adj = (adj:<=ties)
		tiesdiag = sum(diagonal(adj))
		if (selfloop == 0){
			adj = correctDiagonal(adj,0, tiesdiag)
		}
	}
	else {
		adj = tiesGenerator(nodes, ties)
		tiesdiag = sum(diagonal(adj))
		if (selfloop == 0){
			adj = correctDiagonal(adj,1, tiesdiag)
		}
	}
	return(adj)
}

real matrix function tiesGenerator(real scalar nodes, real scalar ties)
{
	real matrix X
	real scalar temp
	
	ties = ties / 2
	temp = ((nodes * (nodes-1) / 2) + nodes)
	X = invvech(jumble((1::temp)))
	X = (X:<=ties)
	return(X)
}

real matrix function dyadcensusGenerator( scalar nodes, scalar mutual, scalar asym)
{
	real matrix X
	real scalar temp, ties, M, A, tiesdiag, T, R, Rlower, Rupper, Rboth
	
	ties = ties / 2
	temp = ((nodes * (nodes-1) / 2) + nodes)
	X = invvech(jumble((1::temp)))
	M = (X:<=mutual)
	A = (X:> mutual):*(X:<= (asym + mutual))
	
	tiesdiag = sum(diagonal(M))
	M = correctDiagonal(M,1, tiesdiag )
	_diag(M,0)
	
	T = M :+ A
	T = T :/ T
	_editmissing(T,0)
	_diag(T, 0)

	tiesdiag = (2 * (mutual + asym) - sum(T)) / 2	
	T = correctDiagonal(T,1, tiesdiag)
	T = T :/ T
	_editmissing(T,0)
	_diag(T, 0)

	A = T :- M
	R = round(runiform(nodes, nodes))
	
	Rlower = lowertriangle(R, 0)
	Rupper = uppertriangle(J(nodes, nodes, 1) - Rlower',0)
	Rboth = Rlower + Rupper
	A = A:* Rboth
	return(M :+ A)
}

real matrix function correctDiagonal(real matrix net, scalar undirected, scalar tiesdiag){
	real scalar nodes, i, found, ran, rrow, rcol
	
	nodes = rows(net)
	for (i = 1 ; i <= tiesdiag; i++ ) {
		found = 0
		while (found == 0) {
			ran = (ceil(runiform(1,2):* nodes))
			rrow = ran[1,1]
			rcol = ran[1,2]
			if ((net[rrow, rcol] == 0) & (rrow != rcol))  {
				found = 1
				net[rrow, rcol] = 1
				if (undirected == 1){
					net[rcol, rrow] = 1
				}
			}
		}
	}
	_diag(net, 0)
	return(net)
}
end

