capture program drop nwfromedge
program nwfromedge
	syntax varlist(min=2 max=3) [if] [, xvars name(string) vars(string) labs(string asis) edgelabs(string) stub(string) directed undirected]
		
	if "`if'" != ""{ 
		keep `if'
	}
	local fromvar : word 1 of `varlist'
	local tovar : word 2 of `varlist'
	if (wordcount("`varlist'") == 3) {
		local value : word 3 of `varlist'
		_extract_valuelabels `value'
		local edgelabs "`r(valuelabels)'"
	}
	else {
		local value ""
	}

	tempfile dictionary
	qui {
		preserve
		// Generate a dictionary that maps the raw id's from the edgelist to consecutive id numbers.
		keep `fromvar' `tovar'
		stack `fromvar' `tovar', into(_rawid) clear
		keep _rawid
		egen _id = group(_rawid)
		collapse (mean) _rawid, by(_id)
		sort _rawid
		save `dictionary', replace
		sort _id 
		if `"`labs'"' == ""{
			local labs "" 
			forvalues i = 1 / `=_N' {
				local onelab = _rawid[`i']
				local labs "`labs' `onelab'"
			}
		}
		restore
	
		// Map raw id's with dictionary
		gen _rawid = `fromvar'
		sum _rawid
		sort _rawid
		merge m:1 _rawid using `dictionary', nogenerate
		rename _id __fromid 
		replace _rawid = `tovar'
		drop `fromvar' `tovar'
		sort _rawid
		merge m:1 _rawid using `dictionary', nogenerate
		rename _id __toid
		drop _rawid
	
		// Generate link variable (net)
		sum __fromid
		local maxNodes = r(max)
	
		gen mynet = (__fromid!=. & __toid != .)
		replace __fromid = __toid if __fromid == .
		replace __toid = __fromid if __toid == .
	
		if "`value'" != "" {
			replace mynet = mynet * `value'
		}
		sort __fromid __toid
		collapse (max) mynet, by(__fromid __toid)
		drop if __fromid == . & __toid == .
	
		// Get adjacency matrix of edgelist in Stata
		reshape wide mynet, i(__fromid) j(__toid)
		foreach var of varlist mynet* {
			replace `var' = 0 if `var' == .
		}
		capture drop `value' __fromid
	}
	local nodes = _N
	
	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "network"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	nwvalidate `name'
	local edgename = r(validname)
	local varscount : word count `vars'
	
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(`stub')
		local edgevars "$validvars"
		
	}
	else {
		local edgevars "`vars'"
	}
	
	// Set the new network
	qui nwset mynet*, name(`edgename') vars(`edgevars') labs(`labs') edgelabs(`edgelabs')
	qui drop _all
	if "`xvars'" == "" {
		qui nwload
	}
	if "`directed'" == "" {
		nwsym, check 
		if "`r(is_symmetric)'" == "true" {
			nwsym
		}
	}
	if "`undirected'" != "" {
		nwsym
	}
	
	di 
	di "{txt}{it:Loading successful}"
	nwsummary
end
