capture program drop nwaddnodes
program nwaddnodes
	syntax [anything(name=something)], [vars(string)]

	qui nwset
	
	local something_count = wordcount("`something'")
	if (`something_count' > 2) {
		di "{err}Command wrongly specified."
		err 6099
	}
	
	local netname : word 1 of `something'
	capture nwname `netname'
	
	if (_rc == 6001) {
		nwcurrent
		local netname = r(current)
		local newnodes : word 1 of `something'
	}
	else {
		local newnodes : word 2 of `something'
	}
	
	nwname `netname'
	local id = r(id)
	local nodes = r(nodes)
	
	if "`stub'" == "" {
		local stub = "new"
	}
	
	if ("`vars'" == "") {
		// Generate temporary varlist and check for each variable if it already exists.
		local vars = "" 	
		local invalid = 0
		forvalues i=1/`newnodes' {
			local vars "`varlist' `stub'`i'"
			capture confirm variable `stub'`i'
			if !_rc {
				local invalid = `invalid' + 1
			}
		}
		// Finds valid Stata variable names to store network.
		if `invalid' > 0 { 
			local stub_add = 0
			while `invalid' > 0 {
				local vars = ""
				local stub_add = `stub_add' + 1
				local invalid = 0
				forvalues i=1/`newnodes' {
					local vars "`vars' `stub'`stub_add'_`i'"
					capture confirm variable `stub'`stub_add'_`i'
					if !_rc {
						local invalid = `invalid' + 1
					}
				}
			}
		}
	}
	else {
		preserve
		drop _all
		nwload `netname'
		foreach onevar in `vars'  {
			capture confirm variable `onevar'
			if (_rc == 0) {
				di "{err}Node variable `onevar' already in use for this network. Choose option vars() differently."
				error 6070
			}
		}
		local vars_count : word count `vars'
		if (`vars_count' != `newnodes') {
				di "{err}Wrong number of new variables in option vars()."
				error 6070	
		}
		restore
	}
	
	local newnodes = `nodes' + `newnodes'
	
	local vecmat = "1"
	forvalues i = 2/`nodes' {
		local vecmat "`vecmat',`i'"
	}
	
	nwtomata `netname', mat(oldmat)
	mata: newmat = J(`newnodes',`newnodes', 0)
	mata: newmat[(`vecmat'),(`vecmat')] = oldmat
	
	scalar onevars = "\$nw_`id'"
	local oldvars `=onevars'
	capture drop `oldvars'
	
	nwreplace `netname', newmat(newmat) nocheck nosync
	global nwsize_`id' = `newnodes'
	global nw_`id' "`oldvars' `vars'" 
	nwload `netname'
		
	mata: mata drop newmat
end


