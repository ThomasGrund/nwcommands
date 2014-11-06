// date: 24aug2014
// author: Thomas Grund, Linköping University

*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwvalidvars
program nwvalidvars
	syntax anything(name=nodes), stub(string)
	
	// Generate temporary varlist and check for each variable if it already exists.
	local varlist = "" 	
	local invalid = 0
	forvalues i=1/`nodes' {
		local varlist "`varlist' `stub'`i'"
		capture confirm variable `stub'`i'
		if !_rc {
			local invalid = `invalid' + 1
		}
	}
	// Finds valid Stata variable names to store network.
	if `invalid' > 0 { 
		local stub_add = 0
		while `invalid' > 0 {
			local varlist = ""
			local stub_add = `stub_add' + 1
			local invalid = 0
			forvalues i=1/`nodes' {
				local varlist "`varlist' `stub'`stub_add'_`i'"
				capture confirm variable `stub'`stub_add'_`i'
				if !_rc {
					local invalid = `invalid' + 1
				}
			}
		}
	}
	global validvars "`varlist'"
end
	