*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwrandom
program nwrandom
	syntax anything(name=nodes), [ntimes(integer 1) Density(string) Prob(string) vars(string) stub(string) name(string) undirected xvars noreplace * ]
	version 9.0
	set more off
	// Check if this is the first network in this Stata session
	if "2" == "" {
		global nwtotal = 0
	}

	// Generate valid network name and valid varlist
	if "" == "" {
		local name "random"
	}
	if "" == "" {
		local stub "net"
	}
	nwvalidate 
	local randomname = r(validname)
	local varscount : word count 
	if ( != ){
		nwvalidvars , stub()
		local randomvars " net1_1 net1_2 net1_3 net1_4 net1_5 net1_6 net1_7 net1_8 net1_9 net1_10 net1_11 net1_12"
	}
	else {
		local randomvars ""
	}
	
	if  != 1 {
		di in smcl as txt "{p}"
		forvalues i = 1/{
			if mod(, 25) == 0 {
				di in smcl as txt "..."
			}
			nwrandom , name(_) density() prob() stub()  
		}
		exit
	}
	
	// Generate probability network as Mata matrix
	if ("" != "") {
		mata: newmat = J(, , 0)
		if "" == "" {
			mata: newmat = floor(uniform(,) :+ )
		}	
		else {
			mata: newmat = makesymmetric(floor(uniform(,) :+ ))
		}
		mata: for (i=1; i<=; i++) newmat[i,i] = 0
		mata: mata drop i
			}
	if ("" != "") {
		local ties = floor(( * ( -1)) * )
		local n2 = *
		if ("" == ""){
			mata: newmat=(1::)
			mata: _jumble(newmat)
			mata: newmat=colshape(newmat, )
			mata: newmat = (newmat:<=)
		}
		else {
			mata: newmat = helper(, )
			mata: tiesDiag = sum(diagonal(newmat))
			mata: st_numscalar("r(tiesdiag)", tiesDiag)
		}
	}
	
	if (""=="" & ""==""){
		di "{err}either {it:prob}() or {it:density}() missing"
		exit
	}
	
	local tiesdiag = r(tiesdiag)
	mata: st_rclear()
	nwset, mat(newmat) vars() name() 
	
	// correct for ties on diagonal
	qui if ("" != "" & "" != ""){
		forvalues i = 1/ {
			local found = 0
			while ( == 0) {
				local rrow =  ceil((- 1)* uniform()) + 1
				local rcol =  ceil((- 1)* uniform())
				nwvalue [, ]
				if r(value) == 0 {
					local found = 1
					nwreplace [,]=1
					continue, break
				}
			}
		}
		nwsym 
	}

	nwload ,  
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

