capture program drop nwsmall
program nwsmall
	syntax anything(name=nodes), k(integer) [ ntimes(integer 1) vars(string) stub(string) name(string) prob(string) shortcuts(string) undirected noreplace xvars]
	
	if "`prob'" != "" {
		if (`prob' > 1) | (`prob' < 0){
			di "{err}Probability needs to be between 0 and 1.{txt}"
		}
	}
	if "`density'" != "" {
		if (`density' > 1 | `density' < 0){
			di "{err}Density needs to be between 0 and 1.{txt}"
		}
	}
	local directed = ("`undirected'" == "")
	
	// Check if this is the first network in this Stata session
	if "$nwtotal" == "" {
		global nwtotal = 0
	}

	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "small"
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
			nwsmall `nodes', k(`k') name(`name'_`i') shortcuts(`shortcuts') prob(`prob') stub(`stub') `xvars' `undirected'
		}
		exit
	}
	
	
	if ("`prob'"=="" & "`shortcuts'"==""){
		di "{err}either {it:prob}() or {it:shortcuts}() missing"
		exit
	}
	
	if "`prob'" != "" {
		mata: newmat = smallworldprob(`nodes', `k', `prob', `directed')
	}
	if "`shortcuts'" != "" {
		mata: newmat = smallworldsk(`nodes', `k', `shortcuts', `directed')
	}
	nwset, mat(newmat) vars(`smallvars') name(`smallname') `undirected' 

	nwload `smallname', `xvars' 

end

capture mata: mata drop smallworldsk()
capture mata: mata drop smallworldprob()
capture mata: mata drop insideBand()

mata: 
real matrix smallworldsk(nodes, k, shortcuts, directed){
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
	
	// initial list of ties to rewire
	rewires = runiform(shortcuts, 2)
	rewires[,1] = ceil(rewires[,1]:* nodes)
	
	if (directed == 0) {
		blub = ceil(rewires[,2]:*k)
		blub2 = editvalue(mod((rewires[,1] :+ blub), nodes), 0, nodes)
		rewires[,2] = blub2[,1]
	}
	if (directed == 1) {
		sign = round(runiform(shortcuts,1))
		sign = J(shortcuts,1,1) :- (sign :* 2) 
		rewires[,2] = editvalue(mod((rewires[,1] :+ (ceil(rewires[,2]:*k):*sign)), nodes),0,nodes)
	}
	
	alreadyRewired = 0
	for (i = 1; i<= shortcuts; i++) {		
		//make sure that tie to rewire is valid
		alreadyRewired = 1
		while (alreadyRewired == 1){
			alreadyRewired = 0
			if (net[rewires[i,1],rewires[i,2]] == 0){
				alreadyRewired = 1
			
				rewires[i,1] = ceil(runiform(1,1) * nodes)
				if (directed == 0) {
					rewires[i,2] = runiform(1,1)
					rewires[i,2] = editvalue(mod(rewires[i,1] :+ ceil(rewires[i,2]:*k), nodes), 0, nodes)
				}
				if (directed == 1) {
					sign = round(runiform(1,1))
					sign = 1 :- (sign :* 2) 
					rewires[i,2] = editvalue(mod(rewires[i,1] :+ (ceil(rewires[i,2]:*k):*sign), nodes),0,nodes)
				}
			}
		}	
		
		rx_old = rewires[i,1]
		ry_old = rewires[i,2]
		
		//require new tie
		wrongPick = 1
		while(wrongPick == 1){
			wrongPick = 0
			ry = ceil(runiform(1,1) :* nodes)
			wrongPick = (((insideBand(nodes, k, rx_old, ry)) == 1) | (net[rx_old, ry] != 0)) 
		}
		net[rx_old,ry] = 1
		if (directed == 0) {
			net[ry,rx_old] = 1
		}
		
		// delete old tie
		net[rx_old,ry_old ] = 0
		if (directed == 0) {
			net[ry_old ,rx_old ] = 0
		}		
	}
	
	return(net)
}

real scalar insideBand(nodes, k, ego, alter) {
	inside = 0
	
	if (((ego - alter) <= k) & (ego >= alter)) {
		inside = 1
	}
	
	if (((ego - alter) > k ) & (((alter + nodes) - ego) <= k)) {
		inside = 1
	}

	if (((alter - ego) <= k) & (alter >= ego)) {
		inside = 1
	}
	
	if (((alter - ego) > k) & (((ego + nodes) - alter) <= k)) {
		inside = 1
	}
	if (ego == alter){
		inside = 1
	}
	return(inside)
} 

real matrix smallworldprob(nodes, k, prob, directed) {

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
	// undirected network
	if (directed == 0) {
		// loop through all nodes
		for (ego = 1; ego<= rows(y); ego++){
			// loop through all undirected ties for each node
			for (i = 1; i <= k; i++) {
				alter = mod((ego + i), nodes)
				if (alter == 0) {
					alter = nodes
				}
				
				// undirected tie to potentially rewire between ego and alter
				if (runiform(1,1) <= prob){
				
					// find new tie
					wrongPick = 1
					while(wrongPick == 1){
						wrongPick = 0
						alter_new = ceil(runiform(1,1) :* nodes)
						wrongPick = (((insideBand(nodes, k, ego, alter_new)) == 1) | (net[ego, alter_new] != 0)) 
					}
					
					
					//rewire undirected tie from ego to alter
					net[ego, alter] = 0
					net[alter, ego] = 0
					net[ego, alter_new] = 1
					net[alter_new, ego] = 1	
				}
			}
		}
	}
	
	// directed network
	if (directed == 1) {
		// loop through all nodes
		for (ego = 1; ego<= rows(y); ego++){
			// loop through all directed ties for each node
			for (i = (-k); i <= k; i++) {
				// exclude self-loops
				if (i != 0) {
					
					alter = mod((ego + i), nodes)
					if (alter == 0) {
						alter = nodes
					}
					// directed tie to potentially rewire between ego and alter
					if (runiform(1,1) <= prob){
					
						// find new tie
						wrongPick = 1
						while(wrongPick == 1){
							wrongPick = 0
							alter_new = ceil(runiform(1,1) :* nodes)
							wrongPick = (((insideBand(nodes, k, ego, alter_new)) == 1) | (net[ego, alter_new] != 0)) 
						}
					
						//rewire directed tie from ego to alter
						net[ego, alter] = 0
						net[ego, alter_new] = 1
					}
				}
			}
		}
	}
	
	return(net)
}
end


*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
