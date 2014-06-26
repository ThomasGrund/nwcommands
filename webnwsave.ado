capture program drop webnwsave
program webnwsave
	syntax anything [,*]
	local webname = subinstr("`anything'", ".dta","",.)

	_nwsyntax _all, max(99999)
	local nets = `networks'
	
	local maxNets = floor((c(max_k_theory) - c(k))/ 12)
	if `maxNets' < `nets' {
		di "{err}Current settings only allow to save {bf:`maxNets'} {it:networks} using Stata format. Restart Stata and increase {bf:set maxvar} or, alternatively, use {bf:nwexport} instead." 
		error 6102
	}
	
	qui {
	local nodes = 0
	local i = 1
	
	tempfile attributes
	capture drop _var* _label*
	gen _running = _n
	foreach onenet in `netname' {
		nwname `onenet'
		local varstodelete "`r(vars)'"
		foreach onevar in `varstodelete' {
			capture drop `onevar'
		}
	}
	save `attributes', replace
	
	clear
	gen _fromid = .
	gen _toid = .
	tempfile edgelist_all
	save `edgelist_all'
	
	foreach onenet in `netname' {
		tempfile edgelist_`onenet'
		nwtoedge `onenet'
		rename `onenet' _`onenet'
		save edgelist_`onenet', replace
		merge m:m _fromid _toid using `edgelist_all', nogenerate
		save `edgelist_all', replace
	}

	gen _format = "" 
	gen _nets = . 
	gen _name = ""
	gen _size = .
	gen _directed = ""
	gen _edgelabs = ""
	
	local i = 1
	
	foreach onenet in `netname' {
		nwname `onenet'
		replace _name = "`r(name)'" in `i'
		local nodes = `r(nodes)'
		replace _size = `nodes' in `i'
		replace _directed = "`r(directed)'" in `i'
		replace _edgelabs = `"`r(edgelabs)'"' in `i'
		nwload `onenet', labelonly
		rename _label _newlabel`i'
		rename _var _newvar`i'
		local i = `i' + 1
	}
	
	forvalues i = 1/`nets' {
		rename _newlabel`i' _label`i'
		rename _newvar`i' _var`i'
	}

	replace _format = "edgelist" in 1
	replace _nets = `nets' in 1
	
	order _format _nets _name _size _directed _edgelabs _var* _lab* _fromid _toid
	gen _running = _n
	qui merge m:m _running using `attributes', nogenerate
	drop _running
	}
	
	save `webname'.dta, `options'
	
end



	

