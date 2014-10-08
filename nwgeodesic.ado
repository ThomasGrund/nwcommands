*! Date        : 3oct2014
*! Version     : 1.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwgeodesic
program nwgeodesic
	version 9
	syntax [anything(name=netname)], [ vars(string) noreplace id(string) name(string) xvars  unconnected(string) nosym]

	_nwsyntax `netname', max(1)
	mata: nw_geo = nw_mata`id'	
	mata: nw_geo = nw_geo :/ nw_geo
	mata: _editmissing(nw_geo, 0)
	
	local symmetrized = 0
	if "`sym'" == "" {
		//di "{txt}Geodesics calculated on the symmetrized network (lower triangle)."
		mata: _makesymmetric(nw_geo)
		local symmetrized = 1
	}
	
	if "`name'" == "" {
		local name "geodesic"
	}

	mata: distances = getgeodesic(nw_geo)
	
	if "`unconnected'" != "" {
		if "`unconnected'" == "max" {
			mata: _editvalue(distances, -1, (max(distances) + 1))
		}
		
		capture confirm number "`unconnected'"
		if _rc == 0 {
			mata: _editvalue(distance, -1, `unconnected')
		}
		mata: lgc = J(`nodes',1,1)
	}
	else qui {
		tempvar comp
		tempvar lgc
		capture rename _components `comp'
		capture rename _lgc `lgc'
		nwcomponents `netname', lgc
		putmata lgc = _lgc if _n <= `nodes'
		capture replace _lgc `lgc'
		capture replace _component `comp'
	}
	
	mata: diagonal = diagonal(distances)
	mata: distances = distances - diag(diagonal)
	mata: distances_lgc = select(select(distances,lgc), lgc')

	if "`vars'" == "" {
		local vars = "_geo1"
		capture drop _geo1
		local onesize "\$nwsize_`id'"
		forvalues i=2/`=`onesize''{
			local vars "`vars' _geo`i'"
		}
	}
	
	foreach v in `vars' {
		capture drop `v'
	}

	nwset, name(`name') mat(distances) vars(`vars')	
	nwcurrent
	local geonet = r(current)
	
	if "`xvars'" == "" {
		capture drop `vars'
		nwtostata, mat(distances) gen(`vars')
	}
	
	mata: st_rclear()
	mata: st_numscalar("r(nodes)", `nodes')
	mata: st_global("r(netname)","`netname'")
	mata: st_numscalar("r(lgc_nodes)", sum(lgc))
	mata: st_numscalar("r(symmetrized)", `symmetrized')
	mata: st_numscalar("r(diameter)", max(distances_lgc))
	mata: st_numscalar("r(avgpath)", sum(distances_lgc) / ( rows(distances_lgc)^2 - rows(distances_lgc)))
	
	mata: mata drop nw_geo
	mata: mata drop distances
	mata: mata drop diagonal 
	mata: mata drop lgc
	mata: mata drop distances_lgc

	if "`unconnected'" == "" {
		local unconnected = "largest component only"
	}
		
	di "{hline 40}"
	di "{txt}  Network name: {res}`netname'"
	di "{txt}  Network of shortest paths: {res}`geonet'"
	di "{hline 40}"
	di "{txt}    Nodes (total): {res}`r(nodes)'"
	di "{txt}    Nodes (largest component): {res}`r(nodes)'"
	di "{txt}    Unconnnected : {res}`unconnected'"
	di "{txt}    Symmetrized : {res}`symmetrized'"
	di "    {hline 36}"
	di "{txt}    Diameter: {res}`r(diameter)'"
	di "{txt}    Average shortest path: {res}`r(avgpath)'"
end

capture mata mata drop getgeodesic()
capture mata mata drop distances()

mata:
real matrix getgeodesic(real matrix nwadj)
{
	distances = distances(nwadj)
	if (min(distances) >= 0 ) { 
		avgdist = sum(distances)/(rows(nwadj)*rows(nwadj) - rows(nwadj))
		st_numscalar("r(L)", avgdist) 
	}
	else {
		st_numscalar("r(L)", -1) 
	}
	return(distances)
}

//function returns matrix of distances. When distance is infinite missing is returned.
real matrix distances(real matrix nw) {	
	real scalar nodes
	real matrix power
	real matrix distance
	real matrix found

	
	nodes = rows(nw)
	found = nw
	distance = nw
	power = nw
	
	i= 1	
	while (i<= (nodes / 2) & sum(found)< nodes*nodes - nodes ) {
		i = i+1
		power = power * nw
		power = power:/power
		_editmissing(power,0)
		temp = power - found - I(nodes)
		_editvalue(temp, -1, 0)
		temp = temp * i
		distance = distance + temp
		found = distance:/distance
		_editmissing(found, 0)	
	}
	_editvalue(distance, 0, -1)
	distance = distance + I(nodes)
	return(distance)
}
end

