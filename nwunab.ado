capture program drop nwunab
program nwunab, rclass
	syntax anything, [ min(passthru) max(passthru)]
	gettoken macro_name _temp : anything, parse(":")
	gettoken _temp netlist : _temp
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
