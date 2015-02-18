*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwcurrent
program nwcurrent
	syntax [anything(name=netname)] [,id(string)]

	// Set a new current network.
	if "`id'" != "" | "`netname'" != "" {
		if ("`id'" != "") {
			nwname, id(`id')
		}
		else {
			_nwsyntax `netname', max(1)
			nwname `netname'
		}

		local j = r(id)
		local i = $nwtotal
		
		// Exchange networks i and j
		
		// Get info from network j
		scalar tonevars_j = "\$nw_`j'"
		scalar tonelabs_j = "\$nwlabs_`j'"
		
		local tname_j = r(name)
		local tdirected_j = r(directed)
		local tsize_j = r(nodes)
		local tvars_j `=tonevars_j'
		local tlabs_j `=tonelabs_j'	
		mata: tnet_j = nw_mata`j'
		
		// Get info from network i
		scalar onename = "\$nwname_`i'"
		scalar onenw = "\$nw_`i'"
		scalar onedirected = "\$nwdirected_`i'"
		scalar onesize = "\$nwsize_`i'"
		scalar onelabs = "\$nwlabs_`i'"
		scalar oneedgelabs = "\$nwedgelabs_`i'"
		
		local tlabs_i `"`=onelabs'"'	
		local tedgelabs_i `"`=oneedgelabs'"'
		local tname_i `=onename'
		local tvars_i `=onenw'
		local tsize_i `=onesize'
		local tdirected_i `=onedirected'
		mata: tnet_i = nw_mata`i'
		
		// Set new networks
		global nwname_`i' `tname_j'
		global nw_`i' `tvars_j' 
		global nwdirected_`i' `tdirected_j'
		global nwsize_`i' `tsize_j'
		global nwlabs_`i' `"`tlabs_j'"'
		global nwedglabs_`i' `"`tedgelabs_j'"'
		mata: nw_mata`i' = tnet_j
		
		global nwname_`j' `tname_i'
		global nw_`j' `tvars_i' 
		global nwdirected_`j' `tdirected_i'
		global nwsize_`j' `tsize_i'
		global nwlabs_`j' `"`tlabs_i'"'
		global nwedgelabs_`j' `"`tedgelabs_i'"'
		mata: nw_mata`j' = tnet_i
		
		mata: mata drop tnet_i tnet_j
	}
	
	
	// Populate return vector.
	nwset, nooutput
	local i = $nwtotal
	scalar onename = "\$nwname_`i'"
	local localname `=onename'
	mata: st_rclear()
	mata: st_global("r(current)", "`localname'")
	mata: st_numscalar("r(networks)", $nwtotal)
end
