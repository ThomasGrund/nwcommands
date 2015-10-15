*! Date        : 13oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwset	
program nwset
syntax [varlist (default=none)][, keeporiginal xvars clear nwclear nooutput edgelist name(string) vars(string) labs(string) labsfromvar(string) abs(string asis) edgelabs(string asis) detail mat(string) undirected directed]
	set more off
	unw_defs
	
	capture mata: `nw'
	if "`_dta[NWversion]'" == "" | _rc != 0 {
		char _dta[NWversion] = "2"
		mata: `nw' = nws_create()
	}
	
	if "`edgelist'" != "" {
		local labsfromvar ""
	}
	if "`clear'" != "" {
		nwdrop _all, netonly
		exit
	}
	if "`nwclear'" != "" {
		nwclear
		exit
	}	
	
	local numnets = 0
	mata: st_rclear()
	local max_nodes = 0
	local allnames ""
	
	qui if "`edgelist'" != "" {
		qui nwfromedge `varlist', name(`name') `xvars' `keeporiginal' `undirected'
		exit
	}
	
	// display information about network
	if ("`varlist'" == "" & "`mat'" == "") {
		mata: st_local("networks", strofreal(nw.nws.get_number()))
		mata: st_local("nets", nw.nws.get_names())
		if  ("`output'" == "") {
			di "{txt}(`networks' networks)"
			di "{hline 20}"
			forvalues  i = 1/`networks' {
				local onename : word `i' of `nets'
				di "      {res}`onename'"
			}
		}
	}
	
	// set the network
	else {
		// set network from varlist
		if "`varlist'" != "" {

			local varscount : word count `vars'
			local labscount : word count `labs'
			local varlistcount: word count `varlist'
			if (`varlistcount' > _N ) {
				unab A : _all
				local newvarlist ""
				forvalues j = 1/`=_N' {
					local newvar : word `j' of `varlist'
					local newvarlist "`newvarlist' `newvar'"
				}
				local varlist `newvarlist'
				
			}
			local size: word count `varlist'
			qui nwtomata `varlist', mat(__nwnew)
			local mat = "__nwnew"
			if (`varscount' != `size') unab vars: `varlist'
			if (`labscount' != `size') local labs "`vars'"
		}
		// set network from mata matrix
		else {
			// either varlist or mat needs to be given
			if ("`mat'" == ""){
				di "{err}either {it:varlist} or option {it:mat()} needs to be specfied"
				exit
			}
			// mat is given
			else {
				mata: __nwnew = `mat' 
				mata: st_numscalar("msize", rows(`mat'))
				local size = msize
				local varscount : word count `vars'
				local labscount : word count `labs'
				// generate vars"
				if("`varscount'" != "`size'"){
					local vars ""
					forvalues i = 1/`size' {
						local vars "`vars' `nwvars_def_pref'`i'"
					}
				}
				// get labels
				if (`labscount' != `size'){
					local labs "`vars'"
				}
			}
		}
		
		mata: __nodenames = J(1,0,"")
		forvalues i = 1 / `size' {
			local onelab : word `i' of `labs'
			mata: __nodenames = (__nodenames, "`onelab'")
		}
	
		if "`name'" == "" {
			local name "network"
		}
		
		nw_validate `name'
		if "`r(exists)'"=="true" {
			di "{txt}Netname `name' changed to `r(validname)'."
		}
		local name = r(validname)

		
		local directed = "true"
		if "`undirected'" != "" {
			local directed = "false"
		}
	}
	
	mata: st_rclear()
	mata: st_numscalar("r(networks)", `nws'.get_number())
	mata: st_global("r(names)", `nws'.get_names())
	//mata: st_numscalar("r(max_nodes)", `nws'.get_max_nodes())

	if ("`varlist'" != "" | "`mat'" != ""){
		mata: `nws'.add("`name'")
		
		mata: nodes = rows(__nwnew)
		if "`labsfromvar'" != "" {
			mata: __nwnodenames = st_sdata((1::nodes), "`labsfromvar'")	
		}
		
		_nwsyntax `name'
		mata: `netobj'->create_by_name(__nodenames)
		mata: `netobj'->set_name("`name'")
		mata: `netobj'->set_directed("`directed'")
		mata: `netobj'->set_edge(__nwnew)
	}
	capture mata: mata drop __nwindex __nwnew __nwnodenames
end
