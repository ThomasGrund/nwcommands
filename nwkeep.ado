*! Date        : 15sept2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwkeep 
program nwkeep
	syntax [anything(name=netname)][if/] [in/],[ attributes(string)]
	_nwsyntax `netname', max(9999)
	local keepnets = "`netname'"

	_nwsyntax _all, max(9999)
	foreach k in `keepnets' {
		local netname : subinstr local netname "`k'" "", all word
	}	
	
	if "`if'" == "" & "`in'" == "" {
		nwdrop `netname'
		nwcompressobs
		exit
	}
	else {
		local netname "`keepnets'"

		if "`if'" != "" {
			local if "if (!(`if'))"
		}
	
		if "`in'" != "" {
			local in "in (!(`in'))"
		}
		nwdrop `netname' `if' `in', attributes(`attributes') 
	}
end
	
