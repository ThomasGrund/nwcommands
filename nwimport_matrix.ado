capture program drop nwimport_matrix
program nwimport_matrix
	syntax anything, [name(string) delimiter(string) directed rownames colnames] 
	if "`name'" == "" {
		local name "network"
	}
	clear
	preserve
	
	gettoken fname ending : anything, parse(".")

	local success = 0
	local excel = 0
	local pot_delimiters = `""tab" ";" "," " ""'
	local pot_delimiters_length : word count `pot_delimiters'
	
	local sub_col = ("`colnames'" == "colnames") 
	local sub_row = ("`rownames'" == "rownames")
	
	// Excel file detected
	qui if (strpos("`ending'", "xls") != 0 ){
		local excel = 1
		import excel "`anything'", sheet("Sheet1") clear
		if c(k) != `=`_N'' {
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
		local n = _N + `sub_col'
		if c(k) != `n' {
			local success = 0
			clear
		}
		else {
			local success = 1
		}
	}
	
	
	// Try other delimiters
	if ("`delimiter'" != ""){
		insheet using `"`anything'"', delimiter("`delimiter'") clear
		// Check for failure
		if c(k) != `=`_N' + `sub_col''  {
			local success = 0
		}
		else {
			local success = 1
		}
	}
	
	
	if `success' == 0 {
		di "{err}matrix could not be loaded"
		error 6703
	}
	
	qui if "`colnames'" != "" {
		ds _all
		local first : word 1 of `r(varlist)'
		rename `first' _cls
		local labs ""
		local i = 1
		foreach var of varlist _all {
			if `i' == 1 {
				local column "`var'"
			}
			else {
				local newlab = `column'[`=`i'-1']
				local newvar = strtoname("`newlab'",1)
				local labs "`labs' `newlab'"
				capture rename `var' `newvar'
				if _rc != 0 {
					set more off
					di "{err}{it:nodename} {bf:`newlab'} in first column invalid"
					exit
				}
			}
			local i = `i' + 1
		}
		drop `column'
	}	

	local n = _N 
	if c(k) != `n' {
		di "{err}Something went wrong; data has wrong dimensions."
		error 6703
	}
	
	qui ds
	local labs "`r(varlist)'"
	qui nwset _all, name("`name'") vars(_all) labs(`labs')
	restore
	if "`directed'" == "" {
		nwsym, check 
		if "`r(is_symmetric)'" == "true" {
			nwsym
		}
	}
	di 
	di "{txt}{it:Loading successful}"
	nwsummary
end
