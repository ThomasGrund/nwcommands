capture program drop nwexport
program nwexport
	version 9
	syntax [anything(name=expname)][, session(string) path(string) replace]	
	
	nwset, nooutput
	if "`expname'" == "" {
		nwcurrent
		local expname = r(current)
	}
	
	// export all networks
	if ("`expname'" == "_all"){
		local nets = ""
		forvalues i = 1/$nwtotal {
			scalar onename = "\$nwname_`i'"
			local localname `=onename'
			local nets "`nets' `localname'"
		}	
	}
	else {
		local nets "`expname'"
	}
	
	if ("`expname'" == ""){
		nwexp, path("`path'") `replace'
	}

	local netcount = wordcount("`nets'")
	foreach onenet in `nets'{
		nwexp `onenet', path("`path'") `replace'
	}
	
	// save a session file
	if ("`session'" != ""){
		di "{txt}Creating session file: `session'.nws"
		if "`path'" != "" {
			local sessionfile "`path'/`session'"
		}
		else {
			local sessionfile "`session'"
		}
		file open sessfile using "`sessionfile'.nws", write `replace'
		foreach onenet in `nets' { 
			file write sessfile  "`onenet'" _newline
		}
		if ("`expname'" == "_all" | "`expname'" == ""){
			file write sessfile "$nwname"
		}
		file close sessfile
	}
end
