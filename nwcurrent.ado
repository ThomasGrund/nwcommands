*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwcurrent
program nwcurrent
	syntax [anything(name=netname)] [,id(string)]

	// Set a new current network.
	if "" != "" | "" != "" {
		if ("" != "") {
			nwname, id()
		}
		else {
			_nwsyntax , max(1)
			nwname 
		}

		local j = r(id)
		local i = 2
		
		// Exchange networks i and j
		
		// Get info from network j
		scalar tonevars_j = ""
		scalar tonelabs_j = ""
		
		local tname_j = r(name)
		local tdirected_j = r(directed)
		local tsize_j = r(nodes)
		local tvars_j marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
		local tlabs_j bischeri castellani ginori guadagni lamberteschi pazzi peruzzi pucci ridolfi salviati strozzi tornabuoni	
		mata: tnet_j = nw_mata
		
		// Get info from network i
		scalar onename = ""
		scalar onenw = ""
		scalar onedirected = ""
		scalar onesize = ""
		scalar onelabs = ""
		scalar oneedgelabs = ""
		
		local tlabs_i `"bischeri castellani ginori guadagni lamberteschi pazzi peruzzi pucci ridolfi salviati strozzi tornabuoni"'	
		local tedgelabs_i `""'
		local tname_i flomarriage
		local tvars_i marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
		local tsize_i 12
		local tdirected_i false
		mata: tnet_i = nw_mata
		
		// Set new networks
		global nwname_ 
		global nw_  
		global nwdirected_ 
		global nwsize_ 
		global nwlabs_ `""'
		global nwedglabs_ `""'
		mata: nw_mata = tnet_j
		
		global nwname_ 
		global nw_  
		global nwdirected_ 
		global nwsize_ 
		global nwlabs_ `""'
		global nwedgelabs_ `""'
		mata: nw_mata = tnet_i
		
		mata: mata drop tnet_i tnet_j
	}
	
	
	// Populate return vector.
	nwset, nooutput
	local i = 2
	scalar onename = ""
	local localname flomarriage
	mata: st_rclear()
	mata: st_global("r(current)", "")
	mata: st_numscalar("r(networks)", 2)
end
