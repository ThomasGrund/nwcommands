capture program drop webnwuse
program webnwuse
	syntax anything [, *]
	local webname = subinstr("`anything'", ".dta","",99)

	nwclear
	
	// replace later with webuse
	qui use `webname', `options'

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
			keep fromid toid `nname'
			qui nwfromedge fromid toid `nname' if `nname' != . , name(`name') vars(`vars') labs(`labs') `undirected' `directed'
		}
		if "`frmat'" == "matrix"{
			nwset `vars', name(`name') vars(`vars') labs(`labs') `undirected'
		}
		restore
	}
	if "`frmat'" == "edgelist" {
		drop _* `allnets'
	}
	di 
	di "{txt}{it:Loading successful}"
	nwset
	qui drop if _n > r(max_nodes)
end



	

