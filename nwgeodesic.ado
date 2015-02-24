*! Date        : 3oct2014
*! Version     : 1.1
*! Author      : Thomas Grund, Linkoping University
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
		mata: nw_geo = editvalue((nw_geo + nw_geo'),2,1)
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
		
		capture confirm number `unconnected'
		if _rc == 0 {
			mata: _editvalue(distances, -1, `unconnected')
		}
	}
	
	mata: diagonal = diagonal(distances)
	mata: distances = distances - diag(diagonal)
	mata: unconnected = (distances :== -1)	

	tempvar lgc
	qui nwgen `lgc' = lgc(`netname')
	qui putmata lgc = `lgc' if _n <= `nodes'
	mata: distances_lgc = distances :* (distances :>= 0)	
	mata: unconnected_lgc = (distances_lgc :== -1)

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
	if "`sym'" == "" {
		nwname `name', newdirected("false")
	}
	nwcurrent
	local geonet = r(current)
	
	if "`xvars'" == "" {
		capture drop `vars'
		nwtostata, mat(distances) gen(`vars')
	}
	
	mata: st_rclear()
	mata: st_numscalar("r(nodes)", `nodes')
	mata: st_global("r(netname)","`netname'")
	mata: st_numscalar("r(symmetrized)", `symmetrized')
	mata: st_numscalar("r(numpaths)", sum(lgc)^2 - sum(lgc))

	if "`directed'" == "false" {
		mata: st_numscalar("r(numpaths)", (`r(numpaths)' / 2))
	}
	
	di "{hline 40}"
	di "{txt}  Network name: {res}`netname'"
	di "{txt}  Network of shortest paths: {res}`geonet'"
	di "{hline 40}"
	di "{txt}    Nodes: {res}`r(nodes)'"
	di "{txt}    Symmetrized : {res}`symmetrized'"
	di "    {hline 36}"
	di "{txt}    Paths (largest component) : {res}`r(numpaths)'"
	
	mata: st_numscalar("r(diameter)", max(distances_lgc))
	mata: st_numscalar("r(avgpath)", (sum(distances_lgc) / (sum(lgc)^2 - sum(lgc))))
	mata: st_numscalar("r(lgc_nodes)", sum(lgc))
	di "{txt}    Diameter (largest component): {res}`r(diameter)'"
	di "{txt}    Average shortest path (largest component): {res}`r(avgpath)'"

	//mata: distances
	mata: mata drop nw_geo
	mata: mata drop distances
	mata: mata drop diagonal 
	capture mata: mata drop lgc
	mata: mata drop unconnected
	capture mata: mata drop distances_lgc
	capture mata: mata drop unconnected_lgc

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

	num_found_previous = -1
	num_found = 0
	i = 1
	while ((i<= (nodes / 2)) & (num_found < (nodes*nodes - nodes))) {
	//while ((i<= (nodes / 2)) & (num_found < (nodes*nodes - nodes))  & (num_found > num_found_previous)) {
		i = i+1
		power = power * nw
		power = power:/power
		_editmissing(power,0)
		temp = power - found - I(nodes)
		_editvalue(temp, -1, 0)
		temp = temp * i
		distance = distance + temp
		num_found_previous = num_found
		found = distance:/distance
		num_found = sum(found)
		_editmissing(found, 0)	
	}
	_editvalue(distance, 0, -1)
	distance = distance + I(nodes)
	return(distance)
}
end

