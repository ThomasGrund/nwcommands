capture program drop nwtomata
program nwtomata
version 9
syntax [anything(name=netname)] [if] [, mat(string) end(string) copy] 
	
	capture unab netname : `netname'
	capture confirm variable `netname'
	
	if (_rc != 0){
		local netfound = 1
		qui nwset
		if "`netname'" == "" {
			nwcurrent
			local netname = r(current)
		}
	
		if "`mat'" == "" {
			local mat nwadjview
		}
	
		// No network given. Uses current network instead.
		if (wordcount("`netname'") == 0){
			capture quietly nwset
			if (r(networks) > 0){
				local id = r(networks)
				mata: `mat' = nw_mata`id'
			}
		}
	
		// Input is a specific network,
		if (wordcount("`netname'") == 1){
			capture nwvalidate `netname'
			if (r(exists) == "true") {
				nwname `netname'
				local id = r(id)
				mata: `mat' = nw_mata`id'
			}
		}
	}
	else {			
		unab vars: `netname'
		local size : word count `vars'
		mata: `mat' = st_data((1::`size'),tokens("`vars'"))
	}
	mata: st_rclear()
 end
 