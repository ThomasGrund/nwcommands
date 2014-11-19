*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwkeep 
program nwkeep
	syntax [anything(name=netname)][if/] [in/],[ attributes(string)]
	_nwsyntax , max(9999)
	local keepnets = ""

	_nwsyntax _all, max(9999)
	foreach k in  {
		local netname : subinstr local netname "" "", all word
	}	
	
	if "" == "" & "" == "" {
		nwdrop 
		nwcompressobs
		exit
	}
	else {
		local netname ""

		if "" != "" {
			local if "if (!())"
		}
	
		if "" != "" {
			local in "in (!())"
		}
		nwdrop   , attributes() 
	}
end
	
