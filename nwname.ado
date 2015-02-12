capture program drop nwname
program nwname
	version 9
	syntax [anything(name=netname)], [id(string) newlabs(string) newlabsfromvar(varname) newvars(string) newname(string) newdirected(string) ]
	
	mata: st_rclear()
	
	local nets wordcount("`netname'")
	if `nets' > 1 {
		di "{err}only one {it:netname} allowed"
		error 6055
	}
	
	if ("$nwtotal" == "" | "$nwtotal" == "0"){
		di "{err}no {it:network} found"
		error 6001
	}
	
	if ("`netname'" == "" & "`id'" == ""){
		local id = $nwtotal
	}

	  
	if "`id'" == "" {
	    qui nwunab nets : _all	
		local id : list posof "`netname'" in nets
		mata: st_rclear()
		if `id' == 0 {
			local id = -1
		}
	}
	else {
		scalar onename = "\$nwname_`id'"
		local thisname = onename
		if (`id' < 1 | `id' > $nwtotal) {
			di "{err}index {it:id} out of bounds"
			error 6002
		}
	}

	if "`netname'" == "" & "`id'" != "-1" {
		scalar onename = "\$nwname_`id'"
		local netname = onename
	}
	
	mata: st_numscalar("r(id)", `id')
	if ("`id'" == "-1") {
		di "{err}{it:network} {bf:`netname'} not found"
		mata: st_rclear()
		error 6001
	}
	else {
		local onesize = "\$nwsize_`id'"
		local thissize = "`onesize'"
		
		if "`newlabsfromvar'" != "" {
			if _N < `onesize' {
				di "{err}variable {it:`newlabsfromvar'} invalid
				error
			}
			local newlabs ""
			forvalues i = 1/`onesize' {
				local onelab = `newlabsfromvar'[`i']
				local newlabs "`newlabs' `onelab'" 
			}
		}
		
		local cnewlabs : word count `newlabs'
		local cnewvars : word count `newvars'
				
		if ("`newname'" != "") {
			 nwvalidate `newname', self(`netname')
			global nwname_`id' = "`r(validname)'"
			local thisname = "`r(validname)'"
			if "`r(validname)'" != "`r(tryname)'" {
				di "{txt}Warning: network {bf:`r(tryname)'} already exists. Name has been changed to {bf:`r(validname)'}."
			}
		}
		else {
			scalar onename = "\$nwname_`id'"
			local thisname = onename
		}
		
		if (`cnewlabs' == `thissize') {
			global nwlabs_`id' `"`newlabs'"'
			local thislabs `"`newlabs'"'
		}
		else {
			scalar onelabs = "\$nwlabs_`id'"
			local thislabs = onelabs
			if `cnewlabs' > 0 {
				di "{err}{bf:(`newlabs')} needs to have {bf:`thissize'} words"
				error 60030
			}
		}
		
		if (`cnewvars' == `thissize') {
			global nw_`id' "`newvars'"
			local thisvars "`newvars'"
		}
		else {
			scalar onevars = "\$nw_`id'"
			local thisvars = onevars
			if `cnewvars' > 0 {
				di "{err}{bf:(`newvars')} needs to have {bf:`thissize'} words"
				error 60030
			}
		}
		if ("`newdirected'" != "") {
			_opts_oneof "true false" "newdirected" "`newdirected'" 60040
			global nwdirected_`id' = "`newdirected'"
			local thisdirected = "`newdirected'"
		}
		else {
			scalar onedirected = "\$nwdirected_`id'"
			local thisdirected = onedirected
		}
		if ("`newtitle'" != "") {
			global nwtitle_`id' = "`newtitle'"
			local thistitle = "`newtitle'"
		}
		else {
			scalar onetitle = "\$nwtitle_`id'"
			local thistitle = onetitle
		}
		if (`"`newedgelabs'"' != "") {
			global nwedgelabs_`id' = `"`newedgelabs'"'
			local thisedgelabs = `"`newedgelabs'"'
		}
		else {
			scalar oneedgelabs = "\$nwedgelabs_`id'"
			local thisedgelabs = oneedgelabs
		}
		if ("`newdescription'" != "") {
			global nwdescription_`id' = "`newdescription'"
			local thisdescription = "`newdescription'"
		}
		else {
			scalar onedescription= "\$newdescription`id'"
			local thisdescription = onedescription
		}
		
	}

	//check if there are too many labels 
	
	local lc : word count `thislabs'
	if `lc' > `onesize' {
		local shortenedlabs ""
		forvalues i = 1 / `onesize' {
			local onelab : word `i' of `thislabs'
			local shortenedlabs `"`shortenedlabs' `onelab'"'
		}
		local thislabs `shortenedlabs'
	}
	
	scalar onesize = "\$nwsize_`id'"
	local localsize = onesize
	mata: st_global("r(edgelabs)", `"`thisedgelabs'"')
	mata: st_global("r(labs)", `"`thislabs'"')
	mata: st_global("r(vars)", "`thisvars'")
	mata: st_global("r(directed)", "`thisdirected'")
	mata: st_global("r(name)", "`thisname'")
	
	mata: st_global("r(title)", "`thistitle'")
	mata: st_numscalar("r(nodes)", `localsize')
	
end
