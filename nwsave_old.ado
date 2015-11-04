*! Date        : 29oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwsave_old
program nwsave_old
	syntax anything [, old * format(string)]
	local webname = subinstr("`anything'", ".dta","",.)
	unw_defs
	nw_syntax _all, max(99999)
	local nets r(networks)

	local format = "edgelist"
	
	preserve	
	 qui {
	
	local nodes = 0
	local i = 1

	tempfile attributes
	capture drop _*
	gen _running = _n
	foreach onenet in `netname' {
		nwname `onenet'
		local varstodelete "`r(vars)'"
		foreach onevar in `varstodelete' {
			capture drop `onevar'
		}
	}
	save`old' `attributes', replace
	
	nwtoedge _all

	gen _format = "" 
	gen _nets = . 
	gen _name = ""
	gen _size = .
	gen _directed = ""
	gen _edgelabs = ""

	foreach onenet in `netname' {
		nwname `onenet'
		replace _name = "`r(name)'" in `i'
		local nodes = `r(nodes)'
		replace _size = `nodes' in `i'
		replace _directed = "`r(directed)'" in `i'
		replace _edgelabs = `"`r(edgelabs)'"' in `i'
		nwload `onenet', labelonly
		rename _nwnodename _newlabel`i'
		rename _nodevar _newvar`i'
		local i = `i' + 1
	}
	
	local i = 1
	foreach onenet in `netname' {
		rename _newlabel`i' _nodelab`i'
		rename _newvar`i' _nodevar`i'
		gen _runningnumber = _n
		tostring _runningnumber, replace
		replace _nodevar`i' = "_net`i'_" + _runningnumber
		drop _runningnumber
		local i = `i' + 1
	}	
	
	nwset
	replace _format = "edgelist" in 1
	replace _nets = `r(networks)' in 1
	order _format _nets _name _size _directed _edgelabs _nodevar* 
	gen _running = _n
	qui merge m:m _running using `attributes', nogenerate
	drop _running
	
	}
	save`old' `webname'.dta, `options'
	restore
end

