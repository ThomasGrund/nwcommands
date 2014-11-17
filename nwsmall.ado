capture program drop nwsmall
program nwsmall
	syntax anything(name=nodes), k(integer) [ ntimes(integer 1) vars(string) stub(string) name(string) prob(real 0) shortcuts(integer 0) undirected noreplace xvars]
	
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
		
		// rewire tie
		net[rewires[i,1],rewires[i,2]] = 0
		if (directed == 0) {
			net[rewires[i,2],rewires[i,1]] = 0
		}
			
		//find new tie
		wrongPick = 1
		while(wrongPick == 1){
			wrongPick = 0
			rx = ceil(runiform(1,1) :* nodes)
			ry = editvalue(mod(rx + ceil(runiform(1,1) :* (nodes - 2 * k - 1)),nodes),0, nodes) 
			if (net[rx,ry] != 0) {
				wrongPick = 1
			}
			if (directed == 0) {
				if (net[ry,rx] != 0) {
					wrongPick = 1
				}
			}
		}
		net[rx,ry] = 1
		if (directed == 0) {
			net[ry,rx] = 1
		}
	}
	
	return(net)
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
	
	
	// rewire
	for (i = 1 ; i <= k ; i++) {
			y = (editvalue(mod((rows' :+ i), (nodes)),0,nodes))'
			for (j = 1; j<= rows(y); j++){
				if (runiform(1,1) <= prob){
					net[j, y[j,1]] = 0
					if (directed == 0){
						net[y[j,1], j] = 0
					}
				
				
					//find new possible link
					found = 0
					while (found==0){
						rx = ceil(runiform(1,1) * nodes)
						ry = ceil(runiform(1,1) * nodes)
						if (net[rx, ry] == 0){
							found = 1
							net[rx, ry] = 1
							if (directed == 0){
								net[ry, rx] = 1
							}
						}
					}	
				}
			}
	}
	
	if (directed == 1 ) {
		// rewire
			for (i = 1 ; i <= k ; i++) {
				y = (editvalue(mod((rows' :- i), (nodes)),0,nodes))'
				for (j = 1; j<= rows(y); j++){
					if (runiform(1,1) <= prob){
						net[j, y[j,1]] = 0
						if (directed == 0){
							net[y[j,1], j] = 0
						}
				
						//find new possible link
						found = 0
						while (found==0){
							rx = ceil(runiform(1,1) * nodes)
							ry = ceil(runiform(1,1) * nodes)
							if (net[rx, ry] == 0){
								found = 1
								net[rx, ry] = 1
								if (directed == 0){
									net[ry, rx] = 1
								}
							}
						}
					}
				}
		}

	}
	return(net)
}
end


