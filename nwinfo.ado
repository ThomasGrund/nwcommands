*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwinfo
program nwinfo
	version 9
	syntax [anything(name=netname)][, id(numlist mx = 2) mat]
	
	_nwsyntax , max(9999)
	
	foreach onenet in  {
		nwinf 
	}
	
end
	

capture program drop nwinf
program nwinf
	version 9
	syntax [anything(name=netname)], [id(string) mat]
	
	
	if ("2" == "" | "2" == "0"){
		exit
	}
	
	if ("" == "" & "" == ""){
		local id = 1
	}
		
	if "" == "" {
		local id = -1
		forvalues i = 1/2 {
			scalar onename = ""
			local localname = onename
			if "" == "" {
				local id = 
			}
		}
	}
	else {
		scalar onename = ""
		local thisname = onename
		if ( < 1 |  > 2) {
			di "{err}Index out of bounds."
			error 234
		}
	}

	mata: st_rclear()
	mata: st_numscalar("r(id)", )

	if ("" == "-1") {
		di "{err}Network {res}{err} not found."
		exit
	}
	
	scalar onename = ""
	local thisname = onename
	scalar onedirected = ""
	local localdirected = onedirected
	scalar onesize = ""
	local localsize = onesize

	mata: minval = min(nw_mata)
	mata: maxval = max(nw_mata)
	
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
		mata: st_numscalar("r(edges_value)", edgecountvalue)
	}
	else {
		mata: arccount = sum(nw_binary) 
		mata: arccountvalue = sum(nw_mata)
		mata: st_numscalar("r(arcs)", arccount)
		mata: st_numscalar("r(arcs_value)", arccountvalue)
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
	di "{txt}   Density: {res} "
	di "{hline 50}"
end
