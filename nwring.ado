capture program drop nwring
program nwring
	syntax anything(name=nodes), k(integer) [ ntimes(integer 1) vars(string) stub(string) name(string) prob(real 0) undirected noreplace xvars]

	// Check if this is the first network in this Stata session
	if "$nwtotal" == "" {
		global nwtotal = 0
	}

	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "ring"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	nwvalidate `name'
	local smallname = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(`stub')
		local smallvars "$validvars"
	}
	else {
		local smallvars "`vars'"
	}
	
	if `ntimes' != 1 {
		di in smcl as txt "{p}"
		forvalues i = 1/`ntimes'{
			if mod(`i', 25) == 0 {
				di in smcl as txt "...`i'"
			}
			nwring `nodes', k(`k') name(`name'_`i') stub(`stub') `xvars' `undirected'
		}
		exit
	}
	
	mata: newmat = ringlattice(`nodes', `k')
	nwset, mat(newmat) vars(`smallvars') name(`smallname') `undirected' 

	nwload `smallname', `xvars' 

end

capture mata: mata drop ringlattice()

mata: 
real matrix ringlattice(nodes, k){
	// generate ring lattice
	net = J(nodes, nodes, 0)
	rows = (1::nodes)
	for (i = 1; i<=k; i++) {
		y = (editvalue(mod((rows' :+ i), (nodes)),0,nodes))'
		for (j = 1; j<= rows(y); j++){
			net[j, y[j,1]] = 1
		}
		y = (editvalue(mod((rows' :- i), (nodes)),0,nodes))'
		for (j = 1; j<= rows(y); j++){
			net[j, y[j,1]] = 1
		}
	}
	return(net)
}
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
