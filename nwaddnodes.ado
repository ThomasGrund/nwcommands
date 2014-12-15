*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwaddnodes
program nwaddnodes
	syntax [anything(name=netname)], newnodes(integer) [vars(string) labs(string) generate(string)]

	_nwsyntax `netname', max(1)
	
	if "`generate'" != "" {
		nwduplicate `netname', name(`generate')
		_nwsyntax `generate', max(1)
	}
	
	if "`stub'" == "" {
		local stub = "new"
	}
	
	if ("`vars'" == "") {
		// Generate temporary varlist and check for each variable if it already exists.
		local vars = "" 	
		local invalid = 0
		forvalues i=1/`newnodes' {
			local vars "`vars' `stub'`i'"
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
				di "{err}Node variable `onevar' already in use. Choose option vars() differently."
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

	local newnodes_orig + `newnodes'
	local newnodes = `nodes' + `newnodes'
	nwtomata `netname', mat(oldmat)
	mata: newmat = J(`newnodes',`newnodes', 0)
	mata: newmat[|1,1 \ `nodes',`nodes'|] = oldmat
	
	scalar onevars = "\$nw_`id'"
	local oldvars `=onevars'
	capture drop `oldvars'
	
	scalar onelabs = "\$nwlabs_`id'"
	local oldlabs `=onelabs'
	
    //mata: mata drop nw_mata`id'
	mata: nw_mata`id' = newmat
	global nwsize_`id' = `newnodes'
	global nw_`id' "`oldvars' `vars'" 
	
	local wc : word count `labs' 
	local overlap : list labs & oldlabs
	local oc : word count `overlap'
	
	if (`wc' == `newnodes_orig' & `oc' == 0) {
		global nwlabs_`id' "`oldlabs' `labs'"
	}
	else {
		global nwlabs_`id' "`oldlabs' `vars'"
	}
	nwload `netname'

	mata: mata drop newmat
end


