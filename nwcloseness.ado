*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

* Calculates actor closeness centrality according to Sabidussi (1966)
* See Wassermann & Faust (1994, p. 184)

capture program drop nwcloseness
program nwcloseness
	version 9
	syntax [anything(name=netname)] [, GENerate(string)]	
	_nwsyntax `netname', max(9999)
	if `networks' > 1 {
		local k = 1
	}
	
	local gencount : word count `generate'
	if (`gencount' != 3) {
		local generate = "_closeness _farness _nearness"
	}
	
	foreach netname_temp in `netname' {
		qui nwgeodesic `netname_temp', name(_tempgeodesic) `options'
		nwname _tempgeodesic
		nwtomata _tempgeodesic, mat(geodesic)
		mata: far = rowsum(geodesic)
		
		_nwsyntax_other `netname_temp'
		
		mata: nearness = J(`othernodes', 1,1) :/ far
		mata: closeness = nearness :* (`othernodes' - 1)
		local _closeness : word 1 of `generate'
		local _farness : word 2 of `generate'
		local _nearness : word 3 of `generate'
	
		qui capture drop `_closeness'`k'
		qui gen `_closeness'`k' = .
		qui capture drop `_farness'`k'
		qui gen `_farness'`k' = .
		qui capture drop `_nearness'`k'
		qui gen `_nearness'`k' =.
	
		if _N < = `othernodes' {
			set obs `othernodes'
		}

		mata: st_store((1::`othernodes'),"`_closeness'`k'",closeness)
		mata: st_store((1::`othernodes'),"`_farness'`k'",far)
		mata: st_store((1::`othernodes'),"`_nearness'`k'",nearness)
	
		mata: mata drop closeness far nearness geodesic
		nwdrop _tempgeodesic
		
		local k = `k' + 1
	}
end
