*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

* Calculates actor closeness centrality according to Sabidussi (1966)
* See Wassermann & Faust (1994, p. 184)

capture program drop nwcloseness
program nwcloseness
	version 9
	syntax [anything(name=netname) *]	
	_nwsyntax `netname', max(1)
	
	if "`varlist'" == "" {
		local varlist "v*"
	}
	
	scalar onename = "\$nwname_`id'"
	local localname `=onename'
	
	qui nwgeodesic `localname', name(_tempgeodesic) `options'
	nwname _tempgeodesic
	local gid = r(id)
	
	mata: far = rowsum(nw_mata`gid')
	mata: nearness = J(`nodes', 1,1) :/ far
	mata: closeness = nearness :* (`nodes' - 1)

	qui capture drop _closeness
	qui gen _closeness = .
	qui capture drop _farness
	qui gen _farness = .
	qui capture drop _nearness
	qui gen _nearness =.
	
	mata: st_store(.,"_closeness",closeness)
	mata: st_store(.,"_farness",far)
	mata: st_store(.,"_nearness",nearness)
	
	mata: mata drop closeness far nearness
	nwdrop _tempgeodesic
end
