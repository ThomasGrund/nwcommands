capture program drop nwsummary
program nwsummary
	version 9
	syntax [anything(name=netname)], [id(string)]

	if ("`id'" == ""){
		_nwsyntax `netname', max(1) 
	} 
	else {
		if (`id' < 1 | `id' > $nwtotal) {
			di "{err}index {it:id} out of bounds"
			error 6002
		}
	}

	mata: st_rclear()
	mata: st_numscalar("r(id)", `id')
	
	scalar onename = "\$nwname_`id'"
	local thisname = onename
	scalar onedirected = "\$nwdirected_`id'"
	local localdirected = onedirected
	scalar onesize = "\$nwsize_`id'"
	local localsize = onesize
	
	mata: network = nw_mata`id'
	mata: _diag(network, J(rows(network), 1, max(network)))
	mata: minval = min(network)
	mata: maxval = max(network)	
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
		mata: st_numscalar("r(arcs_sum)", arccountvalue)
	}
	
	mata: st_numscalar("r(density)", (sum(nw_binary) / (`localsize' * (`localsize' - 1))))
	
	mata: mata drop nw_binary
	capture mata: mata drop edgecount
	capture mata: mata drop arccount
	capture mata: mata drop edgecountvalue
	capture mata: mata drop arccountvalue

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
	di "{txt}   Minimum value: {res}`r(minval)'"
	di "{txt}   Maximum value: {res}`r(maxval)'"
	di "{txt}   Density: {res} `r(density)'"
	di "{hline 50}"
end
