*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwvalidvars
program nwvalidvars
	syntax anything(name=nodes), stub(string)
	
	// Generate temporary varlist and check for each variable if it already exists.
	local varlist = "" 	
	local invalid = 0
	forvalues i=1/ {
		local varlist " "
		capture confirm variable 
		if !_rc {
			local invalid =  + 1
		}
	}
	// Finds valid Stata variable names to store network.
	if  > 0 { 
		local stub_add = 0
		while  > 0 {
			local varlist = ""
			local stub_add =  + 1
			local invalid = 0
			forvalues i=1/ {
				local varlist " _"
				capture confirm variable _
				if !_rc {
					local invalid =  + 1
				}
			}
		}
	}
	global validvars ""
end
	
