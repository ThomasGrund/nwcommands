capture program drop nwcollapse
program nwcollapse
	syntax [anything] [, name(string) by(varname) *]
	
	preserve
	gettoken stat netname : anything, parse(")")
	if "`netname'" == "" {
		local netname "`stat'"
		local stat = "" 
	}
	else {
		local netname = substr("`netname'", 3,.)
		local stat = substr("`stat'",2,.)
	}

	if "`stat'" == "" {
		local stat = "max"
	}
	_nwsyntax `netname'
	
	if "`name'" == "" {
		local name "`netname'_collapsed"
	}
	nwtoedge `netname', fromvars(`by') tovars(`by')
	
	tempvar _newfrom _newto
	egen `_newfrom' = group(from_*)
	egen `_newto' = group(to_*)	
	replace _fromid = `_newfrom'
	replace _toid = `_newto'
	collapse (`stat') `netname', by(_fromid _toid) `options'
	qui nwfromedge _fromid _toid `netname', name(`name')
	restore
end
