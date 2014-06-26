capture program drop nwtranspose
program nwtranspose 
	version 9
	syntax [anything(name=netname)], [name(string) vars(string) xvars noreplace]
	
	qui nwset
	if "`netname'" == "" {
		nwcurrent
		local netname = r(current)
	}
	nwname `netname'
	local nodes = r(nodes)
	local transname "`netname'"

	if ("`replace'" != ""){
		// generate valid network name and valid varlist
		if "`name'" == "" {
			local name "`netname'_trans"
		}
		
		// generate a new network
		nwduplicate `netname', name(`name')
		local transname "`name'"
	}
	
	// get transpose of network
	nwtomata `transname', mat(transnet)
	mata: transnet = transnet'
	
	nwreplacemat `transnet', newmat(transnet)
	mata: mata drop transnet
end
