capture program drop nwimport_edgelist
program nwimport_edgelist
	syntax anything, [name(string) delimiter(string) directed undirected xvars] 
	if "`name'" == "" {
		local name "network"
	}

	preserve
	clear
	
	gettoken fname ending : anything, parse(".")

	local success = 0
	local excel = 0
	local pot_delimiters = `""tab" ";" "," " ""'
	local pot_delimiters_length : word count `pot_delimiters'
	
	// Excel file detected
	qui if (strpos("`ending'", "xls") != 0 ){
		local excel = 1
		import excel "`anything'", sheet("Sheet1") clear
		if c(k) == 1 | _rc != 0 {
			local success = 0
		}
		else {
			local success = 1
		}
	}

	local i = 1
	qui while (`excel' == 0 & "`delimiter'" == "" & `success' == 0 & `i' <= `pot_delimiters_length'){
		local use_delimiter : word `i' of `pot_delimiters'
		local i = `i' + 1
		
		if "`use_delimiter'" == "tab" {
			local insheet_opt = ", tab clear"
		}
		else {
			local insheet_opt = `", delimiter("`use_delimiter'") clear"'
		}
		
		insheet using `anything' `insheet_opt'
		
		// Check for failure
		if c(k) == 1 | _rc != 0{
			local success = 0
			clear
		}
		else {
			local success = 1
		}
	}
	
	// Try other delimiters
	qui if ("`delimiter'" != ""){
		insheet using `"`anything'"', delimiter("`delimiter'") clear
		// Check for failure
		if c(k) == 1 | _rc != 0 {
			local success = 0
		}
		else {
			local success = 1
		}
	}
	
	if `success' == 0 {
		di "{err}{it:edgelist} could not be loaded"
		restore
		error 6704
	}

	if `c(k)' > 3 | `c(k)' < 2 {
		di "{err}Something went wrong; data has more than three columns."
		restore
		error 6704
	}
	
	nwfromedge _all, name(`name') `directed' `undirected' `xvars'
	restore
end
