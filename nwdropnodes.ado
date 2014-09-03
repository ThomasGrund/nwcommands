*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwdropnodes
program nwdropnodes 
	version 9
	syntax [anything(name=netname)] , [nodes(numlist) keepmat(string) attributes(varlist) netonly]
	_nwsyntax `netname', max(1)
	
	local nodes = r(nodes)
	scalar onevars = "\$nw_`id'"
	local vars `=onevars'
	local newvars ""
	
	scalar onelabs = "\$nwlabs_`id'"
	local labs `=onelabs'
	local newlabs ""
	
	// get new vars and new labs
	local i = 0
	foreach onevar in `vars' {
		local i = `i' + 1
		local onelab : word `i' of `labs'
		mata: st_numscalar("r(include)", `keepmat'[`i',1])
		if ("`r(include)'" == "1") {	
			local newvars "`newvars' `onevar'"
			local newlabs "`newlabs' `onelab'"
		}
		mata: st_rclear()
	}	
		
	// generate new matrix and replace network with this new matrix
	nwtomata `netname', mat(keepnet)
	mata: keepvector = `keepmat'
	mata: keepnet = select(keepnet, keepvector)
	mata: keepvector = keepvector'
	mata: keepnet = select(keepnet, keepvector)
	
	nwreplacemat `netname', newmat(keepnet) vars(`newvars') labs(`newlabs') `netonly'
	
	// deal with attributes that should be synced with the smaller network
	if "`attributes'" != "" {
		foreach attr of varlist `attributes' {
			mata: attr = st_data((1,`nodes'), st_varindex("`attr'"))
			mata: subattr = select(attr, keepvector')
			mata: st_view(attrview=.,(1,sum(keepvector)), "`attr'")
			replace `attr' = .
			mata: attrview[.,.] = subattr
		}
		mata: mata drop attr subattr
	}
	mata: mata drop keepnet keepvector
	//nwcompressobs
end


