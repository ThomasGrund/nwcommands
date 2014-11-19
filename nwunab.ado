*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwunab
program nwunab, rclass
	syntax anything, [ min(passthru) max(passthru)]
	gettoken macro_name _temp : anything, parse(":")
	gettoken _temp netlist : _temp
	preserve
	drop _all
	qui nwset
	foreach n in  {
		gen  = .
	}
	di "Netlist: "
	unab unabnets : ,  
	local numnets : word count ""
	return local networks 
	return local netlist "" 
	c_local  ""
	restore
end
