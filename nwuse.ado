*! Date        : 3sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwuse
program nwuse
	syntax anything [, nwclear clear *]
	local webname = subinstr("`anything'", ".dta","",99)
	
	`clear'
	`nwclear'

	if c(k) > 0 & _N > 0{
		local reloadExisting = "yes"
		gen _running = _n
		tempfile existing 
		save `existing' 
	}
	
	qui use `webname', `options'
	
	//capture {
		confirm variable _format _nets _name _size _directed _edgelabs
		local f = _format[1]
		local nets = _nets[1]
		forvalues i = 1/`nets' {
			local s = _size[`i']
			confirm variable _var`i'
			confirm variable _label`i'
			if "`f'" == "edgelist"{
				local nextname = _name[`i']
				confirm variable _`nextname'
			}
			if "`f'" == "matrix" {
				forvalues j = 1/`s' {
					local nodevar `=_var`i'[`j']'
					confirm variable `nodevar'
				}
			}

			if "`f'" != "matrix" & "`f'" != "edgelist" {
				di "{err}file {bf:`webname'.dta} has the wrong format."
				error 6702	
			}
		}
	//}
	
	if _rc != 0 {
		di "{err}file {bf:`webname'.dta} has the wrong format."
		error 6702
	}

	local frmat = _format[1]
	local nets = _nets[1]
	local allnets ""
	local allnames ""
	forvalues i = 1 / `nets' {
		local name = trim(_name[`i'])
		local allnets "`allnets' _`name'"
		local allnames "`allnames' `name'"
		local size = _size[`i']
		local directed = _directed[`i']
		local edgelabs = _edgelabs[`i']
		local vars ""
		local labs ""
		forvalues j = 1 / `size' {
			local nextvar = _var`i'[`j'] 
			local nextlab = _label`i'[`j']
			local labs "`labs' `nextlab'"
			local vars "`vars' `nextvar'"
		}
	
		if "`directed'" == "false" {
			local directed = ""
			local undirected = "undirected"
		}
		else {
			local directed = "directed"
			local undirected = ""
		}
		preserve
		
		local nname "_`name'"
		if "`frmat'" == "edgelist"{
			keep _fromid _toid `nname'
			qui nwfromedge _fromid _toid `nname' if `nname' != . , name(`name') vars(`vars') labs(`labs') `undirected' `directed'
		}
		if "`frmat'" == "matrix"{
			local _netstub `vars'
			//Error:
			//local _netstublength = length("`_netstub'") - 1
			//local _netstub = substr("`_netstub'",1, `_netstublength')
			nwset `_netstub', name(`name') vars(`vars') labs(`labs') `undirected'
		}
		restore
	}
	
	capture drop _*
	capture drop `allnets'
	foreach onenet in `allnames' {
		nwload `onenet'
	}

	di 
	di "{txt}{it:Loading successful}"
	nwset
	qui drop if _n > r(max_nodes)
	qui if "`reloadExisting'" != "" {
		gen _running=_n
		merge m:m _running using `existing', nogenerate
		drop _running
		
	}
end



	

