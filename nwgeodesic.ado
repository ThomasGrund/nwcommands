*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwgeodesic
program nwgeodesic
	version 9
	syntax [anything(name=netname)], [ vars(string) noreplace id(string) name(string) xvars  unconnected(string) nosym]

	_nwsyntax `netname', max(1)
	mata: nw_geo = nw_mata`id'
	
	mata: nw_geo = nw_geo /: nw_geo
	mata: _editmissing(nw_geo, 0)
	
	if "`sym'" == "" {
		di "{txt}Geodesics calculated on the symmetrized network (lower triangle)."
		mata: _makesymmetric(nw_geo)
	}
	
	if "`name'" == "" {
		local name "geodesic"
	}
	
	mata: distances = getgeodesic(nw_geo)
	
	if "`unconnected'" == "" {
		di "{txt}Non-existent paths are treated as: longest shortest path + 1"
		mata: maxdist = max(distances) + 1
	}
	else {
		di "{txt}Non-existent paths are treated as: "`unconnected'
		mata: maxdist = `unconnected'
	}
	
	mata: _editvalue (distances, -1, maxdist)
	mata: diagonal = diagonal(distances)
	mata: distances = distances - diag(diagonal)

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
	
	if "`xvars'" == "" {
		capture drop `vars'
		nwtostata, mat(distances) gen(`vars')
	}
	mata: mata drop nw_geo
	mata: mata drop distances
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
	while (i<=nodes & sum(found)< nodes*nodes - nodes ) {
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

