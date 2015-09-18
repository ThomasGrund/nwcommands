capture program drop nworder
program nworder
	syntax anything(name=netname) [, *]
	_nwsyntax _all, max(9999) name(allnets)
	
	preserve
	clear
	foreach v in `allnets' {
		gen `v' = .
	}
	if "`options'" != "" {
		qui order `netname', `options'
	}
	else {
		qui order `netname'
	}
	qui ds 
	local newnetlist `r(varlist)'
	restore
	
	local newnetlist `r(varlist)'
	qui foreach onenet in `newnetlist' {
		nwduplicate `onenet', name(_dupl_`onenet')
	}
	qui nwdrop `newnetlist'
	
	qui foreach onenet in `newnetlist' {
		nwname _dupl_`onenet', newname(`onenet')
	}
end


*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
