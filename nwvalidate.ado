*! Date        : 17 Dec 2013
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwvalidate
program nwvalidate
	syntax anything(name=netname) [, self(string) ]
	
	local netname = strtoname("`netname'",1)
	local valid = "false"
	
	local prefix = ""
	local p = 1

	// no network exists yet
	if ("$nwtotal" == ""){
		local checkname = "`netname'"
		local valid = "true"
	}
	
	mata: st_global("r(tryname)", "`netname'")
	
	// at least one other network exists already
	while ("`valid'" == "false") {
		local valid = "true"
		local checkname = "`netname'`prefix'"

		if ("`checkname'" == "$nwname") {
			local valid = "false"
			if "`storageonly'" != "" {
				local valid = "true"
			}
		}
	
		if ("$nwtotal" != ""){
			local k = 1
			if ("`storageonly'" != "") {
				local k = 2
			}
			forvalues i = `k'/$nwtotal {
				scalar onename = "\$nwname_`i'"
				local localname `=onename'
				if ("`checkname'" == "`localname'" & "`self'" != "`checkname'") {
					local valid = "false"
				}
			}
		}
		
		if "`valid'" == "false" {
			local prefix = "_`p'"
			local p = `p' + 1
		}
	}
	
	global validname = "`checkname'"
	mata: st_global("r(validname)", "`checkname'")
	macro drop validname
	
	if r(tryname) != r(validname) {
		mata: st_global("r(exists)", "true")
	}
	else {
		mata: st_global("r(exists)", "false")
	}
	
end
