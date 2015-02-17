*! Date        : 3sept2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwsave
program nwsave
	syntax anything [, old * format(string)]
	local webname = subinstr("`anything'", ".dta","",.)

	_nwsyntax _all, max(99999)
	local nets : word count `netname'

	
	if "`format'" == "" {
		local format = "edgelist"
	}
	if (`=`nodes_all' + 20' > c(max_k_theory)){
		local format = "edgelist" 
	}
	
	_opts_oneof "matrix edgelist" "format" "`format'" 6556
		
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
			capture drop _nodelab
			capture drop _nodevar
			capture drop _nodeid
		}
	}
	save`old' `attributes', replace
	
	if "`format'" == "edgelist" {
		clear
		gen _fromid = .
		gen _toid = .
		tempfile edgelist_all
		save `edgelist_all'
		foreach onenet in `netname' {
			tempfile edgelist_`onenet'
			nwtoedge `onenet'
			rename `onenet' _`onenet'
			save `edgelist_`onenet'', replace
			merge m:m _fromid _toid using `edgelist_all', nogenerate
			save `edgelist_all', replace
		}
	}
	if "`format'" == "matrix" {
		clear
		local i = 1
		foreach onenet in `netname' {
			nwname `onenet'
			local vars "`r(vars)'"
			nwload `onenet'
			capture drop _nodelab _nodevar _nodeid
			local j = 1
			foreach v of varlist `vars' {
				rename `v' _net`i'_`j'
				local j = `j' + 1
			}
			local i = `i' + 1
		}
	}

	gen _format = "" 
	gen _nets = . 
	gen _name = ""
	gen _size = .
	gen _directed = ""
	gen _edgelabs = ""

	local i = 1
	local n = _N
	if `n' < `nets'{
		set obs `nets'
	}
	foreach onenet in `netname' {
		nwname `onenet'
		replace _name = "`r(name)'" in `i'
		local nodes = `r(nodes)'
		replace _size = `nodes' in `i'
		replace _directed = "`r(directed)'" in `i'
		replace _edgelabs = `"`r(edgelabs)'"' in `i'
		nwload `onenet', labelonly
		rename _nodelab _newlabel`i'
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
	
	if "`format'" == "matrix" {
		replace _format = "matrix" in 1
		
	}
	
	if "`format'" == "edgelist" {
		replace _format = "edgelist" in 1
		
	}
	
	replace _nets = `nets' in 1
	order _format _nets _name _size _directed _edgelabs _nodevar* _nodelab*
	gen _running = _n
	qui merge m:m _running using `attributes', nogenerate
	drop _running
	
	}
	save`old' `webname'.dta, `options'
	restore
end



	

