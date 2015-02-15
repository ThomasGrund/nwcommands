*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwrandom
program nwrandom
	syntax anything(name=nodes), [ntimes(integer 1) Density(string) Prob(string) vars(string) labs(string) stub(string) name(string) undirected xvars noreplace * ]
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
			nwrandom `nodes', name(`name'_`i') density(`density') prob(`prob') stub(`stub') `xvars' `undirected' labs(`labs')
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
		}
		else {
			mata: newmat = helper(`nodes', `ties')
			mata: tiesDiag = sum(diagonal(newmat))
			mata: st_numscalar("r(tiesdiag)", tiesDiag)
		}
	}
	
	if ("`prob'"=="" & "`density'"==""){
		di "{err}either {it:prob}() or {it:density}() missing"
		exit
	}
	
	local tiesdiag = r(tiesdiag)
	mata: st_rclear()
	nwset, mat(newmat) vars(`randomvars') name(`randomname') `undirected'
	
	// correct for ties on diagonal
	qui if ("`undirected'" != "" & "`density'" != ""){
		forvalues i = 1/`tiesdiag' {
			local found = 0
			while (`found' == 0) {
				local rrow =  ceil((`nodes'- 1)* uniform()) + 1
				local rcol =  ceil((`rrow'- 1)* uniform())
				nwvalue `randomname'[`rrow', `rcol']
				if r(value) == 0 {
					local found = 1
					nwreplace `randomname'[`rrow',`rcol']=1
					continue, break
				}
			}
		}
		nwsym `randomname'
	}

	local wc : word count `labs'
	if `wc' == `nodes' {
		nwname `randomname', newlabs(`labs')
	}
	nwload `randomname', `xvars' 
	mata: mata drop newmat
end


capture mata: mata drop helper()
mata:
real matrix function helper(real scalar nodes, real scalar ties)
{
	real matrix X
	
	ties = ties / 2
	temp = ((nodes * (nodes-1) / 2) + nodes)
	X = invvech(jumble((1::temp)))
	X = (X:<=ties)
	return(X)
}
end

