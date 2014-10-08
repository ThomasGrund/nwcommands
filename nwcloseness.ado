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
	_nwsyntax `netname', max(1)
	
	if "`varlist'" == "" {
		local varlist "v*"
	}
	local gencount : word count `generate'
	if (`gencount' != 3) {
		local generate = "_closeness _farness _nearness"
	}
	scalar onename = "\$nwname_`id'"
	local localname `=onename'
	
	qui nwgeodesic `localname', name(_tempgeodesic) `options'
	nwname _tempgeodesic
	local gid = r(id)
	mata: far = rowsum(nw_mata`gid')
	mata: nearness = J(`nodes', 1,1) :/ far
	mata: closeness = nearness :* (`nodes' - 1)

	local _closeness : word 1 of `generate'
	local _farness : word 2 of `generate'
	local _nearness : word 3 of `generate'
	
	qui capture drop `_closeness'
	qui gen `_closeness' = .
	qui capture drop `_farness'
	qui gen `_farness' = .
	qui capture drop `_nearness'
	qui gen `_nearness' =.
	
	if _N < = `nodes' {
		set obs `nodes'
	}
	mata: st_store(.,"`_closeness'",closeness)
	mata: st_store(.,"`_farness'",far)
	mata: st_store(.,"`_nearness'",nearness)
	
	mata: mata drop closeness far nearness
	nwdrop _tempgeodesic
end
