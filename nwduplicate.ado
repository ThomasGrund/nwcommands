capture program drop nwduplicate
program nwduplicate
	version 9
	syntax [anything(name=netname)], [name(string) vars(string) xvars]
		
	qui nwset
	if "`netname'" == "" {
		nwcurrent
		local netname = r(current)
	}
	
	// get parameters
	nwname `netname'
	local nodes = r(nodes)
	local id = r(id)
	if (r(directed) != "true"){
		local undirected = "undirected"
	}
	
	// generate valid network name and valid varlist
	if "`name'" == "" {
		local name "`netname'_copy"
	}

	nwvalidate `name'
	local copyname = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `nodes'){
		// obtain vars from original
		scalar onevars = "\$nw_`id'"
		local copyvars `=onevars'
	}
	else {
		local copyvars "`vars'"
	}
	
	// create network
	nwtomata `netname', mat(onenet)
	nwset, name(`copyname') vars(`copyvars') mat(onenet) `undirected'
end
