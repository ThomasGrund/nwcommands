capture program drop nwunab
program nwunab, rclass
	syntax anything, [ min(passthru) max(passthru)]
	gettoken macro_name _temp : anything, parse(":")
	local _temp : subinstr local _temp ":" ""
	local _tempcount : word count `_temp'
	local netlist `_temp'

	preserve
	drop _all
	qui nwset
	foreach n in `r(names)' {
		gen `n' = .
	}
	unab unabnets : `netlist', `max' `min'
	local numnets : word count "`unablist'"
	return local networks `numnets'
	return local netlist "`unabnets'" 
	c_local `macro_name' "`unabnets'"
	restore
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
