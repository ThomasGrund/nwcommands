capture program drop nwsummarize
program nwsummarize
	version 9
	syntax [anything(name=netname)][, mat matonly]
	set more off
	_nwsyntax `netname', max(9999)
	
	foreach onenet in `netname' {
		nwinf `onenet', `mat' `matonly'
	}
	
end
	

capture program drop nwinf
program nwinf
	version 9
	syntax [anything(name=netname)], [id(string) mat matonly]
	
	if ("$nwtotal" == "" | "$nwtotal" == "0"){
		exit
	}
	
	if ("`netname'" == "" & "`id'" == ""){
		local id = 1
	}
		
	if "`id'" == "" {
		local id = -1
		forvalues i = 1/$nwtotal {
			scalar onename = "\$nwname_`i'"
			local localname = onename
			if "`localname'" == "`netname'" {
				local id = `i'
			}
		}
	}
	else {
		scalar onename = "\$nwname_`id'"
		local thisname = onename
		if (`id' < 1 | `id' > $nwtotal) {
			di "{err}Index out of bounds."
			error 234
		}
	}

	mata: st_rclear()
	mata: st_numscalar("r(id)", `id')

	if ("`id'" == "-1") {
		di "{err}Network {res}`netname'{err} not found."
		exit
	}
	
	scalar onename = "\$nwname_`id'"
	local thisname = onename
	scalar onedirected = "\$nwdirected_`id'"
	local localdirected = onedirected
	scalar onesize = "\$nwsize_`id'"
	local localsize = onesize

	mata: minval = min(nw_mata`id')
	mata: maxval = max(nw_mata`id')
	
	mata: st_global("r(name)", "`thisname'")
	mata: st_global("r(directed)", "`localdirected'")
	mata: st_numscalar("r(nodes)", `localsize')
	mata: st_numscalar("r(minval)", minval)
	mata: st_numscalar("r(maxval)", maxval)	
	mata: nw_binary = nw_mata`id' :/ nw_mata`id'
	mata: _diag(nw_binary, J(rows(nw_binary),1,0))
				
	if (r(directed)=="false"){
		mata: edgecount = sum(nw_binary) / 2
		mata: edgecountvalue = sum(nw_mata`id') / 2
		mata: st_numscalar("r(edges)", edgecount)
		mata: st_numscalar("r(edges_sum)", edgecountvalue)
	}
	else {
		mata: arccount = sum(nw_binary) 
		mata: arccountvalue = sum(nw_mata`id')
		mata: st_numscalar("r(arcs)", arccount)
		mata: st_numscalar("r(arcs_value)", arccountvalue)
	}
	
	mata: st_numscalar("r(density)", (sum(nw_binary) / (`localsize' * (`localsize' - 1))))
	
	mata: mata drop nw_binary
	capture mata: mata drop edgecount
	capture mata: mata drop arccount
	capture mata: mata drop edgecountvalue
	capture mata: mata drop arccountvalue

	if "`matonly'" == "" {
		di "{hline 50}"
		di "{txt}   Network name: {res} `r(name)'"
		di "{txt}   Network id: {res} `r(id)'"
		di "{txt}   Directed: {res}`r(directed)'"
		di "{txt}   Nodes: {res}`r(nodes)'"
		if (r(directed) == "false"){
			di "{txt}   Edges: {res}`r(edges)'"
		}
		if (r(directed) == "true"){
			di "{txt}   Arcs: {res}`r(arcs)'"
		}
		di "{txt}   Minimum value: {res} `r(minval)'"
		di "{txt}   Maximum value: {res} `r(maxval)'"	
		di "{txt}   Density: {res} `r(density)'"
	}
	
	if "`mat'`matonly'" !=""{
		mata: nw_mata`id'
	}
	//di "{hline 50}"
end
