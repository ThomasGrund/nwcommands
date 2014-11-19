*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwname
program nwname
	version 9
	syntax [anything(name=netname)], [id(string) newlabs(string) newlabsfromvar(varname) newvars(string) newname(string) newdirected(string) newtitle(string) newedgelabs(string asis) newdescription(string)]
	
	mata: st_rclear()
	
	local nets wordcount("")
	if  > 1 {
		di "{err}only one {it:netname} allowed"
		error 6055
	}
	
	if ("2" == "" | "2" == "0"){
		di "{err}no {it:network} found"
		error 6001
	}
	
	if ("" == "" & "" == ""){
		local id = 2
	}

	  
	if "" == "" {
	    qui nwunab nets : _all	
		local id : list posof "" in nets
		mata: st_rclear()
		if  == 0 {
			local id = -1
		}
	}
	else {
		scalar onename = ""
		local thisname = onename
		if ( < 1 |  > 2) {
			di "{err}index {it:id} out of bounds"
			error 6002
		}
	}

	mata: st_numscalar("r(id)", )
	if ("" == "-1") {
		di "{err}{it:network} {bf:} not found"
		mata: st_rclear()
		error 6001
	}
	else {
		local onesize = ""
		local thissize = ""
		
		if "" != "" {
			if _N <  {
				di "{err}variable {it:} invalid
				error
			}
			local newlabs ""
			forvalues i = 1/ {
				local onelab = []
				local newlabs " " 
			}
		}
		
		local cnewlabs : word count 
		local cnewvars : word count 
		
		if ("" != "") {
			global nwname_ = ""
			local thisname = ""
		}
		else {
			scalar onename = ""
			local thisname = onename
		}
		
		if ( == ) {
			global nwlabs_ `""'
			local thislabs `""'
		}
		else {
			scalar onelabs = ""
			local thislabs = onelabs
		}
		if ( == ) {
			global nw_ ""
			local thisvar ""
		}
		else {
			scalar onevars = ""
			local thisvars = onevars
		}
		if ("" != "") {
			global nwdirected_ = ""
			local thisdirected = ""
		}
		else {
			scalar onedirected = ""
			local thisdirected = onedirected
		}
		if ("" != "") {
			global nwtitle_ = ""
			local thistitle = ""
		}
		else {
			scalar onetitle = ""
			local thistitle = onetitle
		}
		if (`""' != "") {
			global nwedgelabs_ = `""'
			local thisedgelabs = `""'
		}
		else {
			scalar oneedgelabs = ""
			local thisedgelabs = oneedgelabs
		}
		if ("" != "") {
			global nwdescription_ = ""
			local thisdescription = ""
		}
		else {
			scalar onedescription= ""
			local thisdescription = onedescription
		}
		
	}

	scalar onesize = ""
	local localsize = onesize
	mata: st_global("r(edgelabs)", `""')
	mata: st_global("r(labs)", `""')
	mata: st_global("r(vars)", "")
	mata: st_global("r(directed)", "")
	mata: st_global("r(name)", "")
	
	mata: st_global("r(title)", "")
	mata: st_numscalar("r(nodes)", )
	
end
