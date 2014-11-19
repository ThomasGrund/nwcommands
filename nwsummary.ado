*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwsummary
program nwsummary
	version 9
	syntax [anything(name=netname)], [id(string)]

	if ("" == ""){
		_nwsyntax , max(1) 
	} 
	else {
		if ( < 1 |  > 2) {
			di "{err}index {it:id} out of bounds"
			error 6002
		}
	}

	mata: st_rclear()
	mata: st_numscalar("r(id)", )
	
	scalar onename = ""
	local thisname = onename
	scalar onedirected = ""
	local localdirected = onedirected
	scalar onesize = ""
	local localsize = onesize
	
	mata: network = nw_mata
	mata: _diag(network, J(rows(network), 1, max(network)))
	mata: minval = min(network)
	mata: maxval = max(network)	
	mata: st_global("r(name)", "")
	mata: st_global("r(directed)", "")
	mata: st_numscalar("r(nodes)", )
	mata: st_numscalar("r(minval)", minval)
	mata: st_numscalar("r(maxval)", maxval)	
	mata: nw_binary = nw_mata :/ nw_mata
	mata: _diag(nw_binary, J(rows(nw_binary),1,0))
				
	if (r(directed)=="false"){
		mata: edgecount = sum(nw_binary) / 2
		mata: edgecountvalue = sum(nw_mata) / 2
		mata: st_numscalar("r(edges)", edgecount)
		mata: st_numscalar("r(edges_sum)", edgecountvalue)
	}
	else {
		mata: arccount = sum(nw_binary) 
		mata: arccountvalue = sum(nw_mata)
		mata: st_numscalar("r(arcs)", arccount)
		mata: st_numscalar("r(arcs_sum)", arccountvalue)
	}
	
	mata: st_numscalar("r(density)", (sum(nw_binary) / ( * ( - 1))))
	
	mata: mata drop nw_binary
	capture mata: mata drop edgecount
	capture mata: mata drop arccount
	capture mata: mata drop edgecountvalue
	capture mata: mata drop arccountvalue

	di "{hline 50}"
	di "{txt}   Network name: {res} "
	di "{txt}   Network id: {res} "
	di "{txt}   Directed: {res}"
	di "{txt}   Nodes: {res}"
	if (r(directed) == "false"){
		di "{txt}   Edges: {res}"
	}
	if (r(directed) == "true"){
		di "{txt}   Arcs: {res}"
	}
	di "{txt}   Minimum value: {res}"
	di "{txt}   Maximum value: {res}"
	di "{txt}   Density: {res} "
	di "{hline 50}"
end
