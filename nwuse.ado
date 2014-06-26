capture program drop nwuse
program nwuse
	syntax anything [, nwclear clear *]
	local webname = subinstr("`anything'", ".dta","",99)
	
	`clear'
	`nwclear'

	qui if c(k) > 0 & _N > 0{
		local reloadExisting = "yes"
		gen _running = _n
		tempfile existing 
		save `existing' 
	}
	
	qui use `webname', `options'
	capture {
		foreach v in "_format _nets _name _size _directed _edgelabs" {
			confirm variable `v'
		}
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
					confirm variable _net`i'_`j'
				}
			}
			if "`f'" != "matrix" | "`f'" == "edelist" {
				di "{err}file {bf:`webname'.dta} has the wrong format."
				error 6702	
			}
		}
	}
	if _rc != 0 {
		di "{err}file {bf:`webname'.dta} has the wrong format."
		error 6702
	}


	local frmat = _format[1]
	local nets = _nets[1]
	local allnets ""
	forvalues i = 1 / `nets' {
		local name = trim(_name[`i'])
		local allnets "`allnets' _`name'"
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
			nwset _net`i'_*, name(`name') vars(`vars') labs(`labs') `undirected'
		}
		restore
	}
	capture drop _*
	capture drop `allnets'
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



	

