*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwrandom
program nwrandom
	syntax anything(name=nodes), [ntimes(integer 1) arcs(integer -1) Census(numlist integer min=1 max=3) Density(string) Prob(string) vars(string) labs(string) stub(string) name(string) undirected xvars noreplace * ]
	version 9.0
	
	set more off
	// Check if this is the first network in this Stata session
	if "$nwtotal" == "" {
		global nwtotal = 0
	}

	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "random"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	nwvalidate `name'
	local randomname = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(`stub')
		local randomvars "$validvars"
	}
	else {
		local randomvars "`vars'"
	}
	
	if `ntimes' != 1 {
		di in smcl as txt "{p}"
		forvalues i = 1/`ntimes'{
			if mod(`i', 25) == 0 {
				di in smcl as txt "...`i'"
			}
			nwrandom `nodes', census(`census') name(`name'_`i') density(`density') prob(`prob') stub(`stub') `xvars' `undirected' labs(`labs')
		}
		exit
	}
	
	// Generate probability network as Mata matrix
	if ("`prob'" != "") {
		mata: newmat = J(`nodes', `nodes', 0)
		if "`undirected'" == "" {
			mata: newmat = floor(uniform(`nodes',`nodes') :+ `prob')
		}	
		else {
			mata: newmat = makesymmetric(floor(uniform(`nodes',`nodes') :+ `prob'))
		}
		mata: for (i=1; i<=`nodes'; i++) newmat[i,i] = 0
		mata: mata drop i
	}
	if ("`density'" != "") {
		local ties = floor((`nodes' * (`nodes' -1)) * `density')
		local n2 = `nodes'*`nodes'
		if ("`undirected'" == ""){
			mata: newmat=(1::`n2')
			mata: _jumble(newmat)
			mata: newmat=colshape(newmat, `nodes')
			mata: newmat = (newmat:<=`ties')
			mata: newmat = correctDiagonal(newmat,0)
		}
		else {
			mata: newmat = tiesGenerator(`nodes', `ties')
			mata: newmat = correctDiagonal(newmat, 1)
		}
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
		mata: newmat = dyadcensusGenerator(`nodes', `mutual', `asym')
	
	}
	
	if ("`prob'"=="" & "`density'"=="" & "`census'" == ""){
		di "{err}either {it:prob}(), {it:density}() or {it:census()} missing"
		exit
	}

	//mata: `tiesDiag'
	mata: st_rclear()
	nwset, mat(newmat) vars(`randomvars') name(`randomname') `undirected'

	local wc : word count `labs'
	if `wc' == `nodes' {
		nwname `randomname', newlabs(`labs')
	}
	
	if "`xvars'" == "" {
		nwload `randomname'
	}
	mata: mata drop newmat
end


capture mata: mata drop tiesGenerator()
capture mata: mata drop correctDiagonal()
capture mata: mata drop dyadcensusGenerator()
mata:
real matrix function tiesGenerator(real scalar nodes, real scalar ties)
{
	real matrix X
	
	ties = ties / 2
	temp = ((nodes * (nodes-1) / 2) + nodes)
	X = invvech(jumble((1::temp)))
	X = (X:<=ties)
	return(X)
}

real matrix function dyadcensusGenerator( scalar nodes, scalar mutual, scalar asym)
{
	real matrix X
	ties = ties / 2
	temp = ((nodes * (nodes-1) / 2) + nodes)
	X = invvech(jumble((1::temp)))
	M = (X:<=mutual)
	A = (X:> mutual):*(X:<= (asym + mutual))
	M = correctDiagonal(M,1)
	T = correctDiagonal((M :+ A),1)
	T = T :/ T
	_editmissing(T,0)
	A = T :- M
	R = round(runiform(nodes, nodes))
	
	Rlower = lowertriangle(R, 0)
	Rupper = uppertriangle(J(nodes, nodes, 1) - Rlower',0)
	Rboth = Rlower + Rupper
	A = A:* Rboth
	return(M :+ A)
}

real matrix function correctDiagonal(real matrix net, scalar undirected){
	nodes = rows(net)
	tiesdiag = sum(diagonal(net))
	for (i = 1 ; i <= tiesdiag; i++ ) {
		found = 0
		while (found == 0) {
			ran = (ceil(runiform(1,2):* nodes))
			rrow = ran[1,1]
			rcol = ran[1,2]
			if ((net[rrow, rcol] == 0) & rrow != rcol) {
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


