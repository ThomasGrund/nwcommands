capture program drop nwlattice
program nwlattice
	syntax anything(name=dims) , [name(string) vars(string) stub(string) xvars noreplace]
	version 9
	set more off
	
	// Check if this is the first network in this Stata session
	if "$nwtotal" == "" {
		global nwtotal = 0
	}
	
	// Get parameters
	local cols = word("`dims'",1)
	local rows = 1
	if (wordcount("`dims'") > 1) {
		local rows = word("`dims'",2)
	}
	local nodes = `cols' * `rows'
	
	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "lattice"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	nwvalidate `name'
	local latticename = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(`stub')
		local latticevars "$validvars"
	}
	else {
		local latticevars "`vars'"
	}
	
	// Generate network	as Mata matrix
	mata: newmat = J(`nodes',`nodes', 0)
	local vars ""
	forvalues i = 1/`nodes' {
		local vars "`vars' lattice`i'"
		local right = `i' + 1
		local left = `i' - 1
		
		local up = `i' - `cols'
		local down = `i' + `cols'
		
		if ((mod(`=`right'-1', `cols') != 0) & `right' <= `nodes') mata: newmat[`i', `right'] = 1
		if ((mod(`left', `cols') != 0) & `left' > 1) mata: newmat[`i', `left'] = 1
		mata: newmat[2,1]=1
		if (`up' > 0) mata: newmat[`i', `up'] = 1 
		if (`down' > 0 & `down' <= `nodes') mata: newmat[`i', `down'] = 1
	}
	
	// Set the new network
	nwset, mat(newmat) vars(`latticevars') name(`latticename') undirected
	nwload `latticename', `xvars'
	mata: mata drop newmat 
	macro drop validname validvars
end


