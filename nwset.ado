*! Date        : 13oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwset	
program nwset
syntax [varlist (default=none)][, bipartite keeporiginal xvars clear nwclear nooutput edgelist name(string) vars(string) labs(string) labsfromvar(string) abs(string asis) edgelabs(string asis) detail mat(string) undirected directed]
	set more off
	unw_defs
	
	capture mata: `nw'
	if ("`_dta[NWversion]'" == "" | _rc != 0) {
		char _dta[NWversion] = "2"
		if ("`varlist'" != "" | "`mat'" != ""){
			mata: `nw' = nws_create()
		}
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
		capture mata: `nw'
		if _rc == 0 {
			mata: st_numscalar("r(networks)", `nws'.get_number())
			mata: st_global("r(nets)", `nws'.get_names())
			if  ("`output'" == "") {
				di "{txt}(`r(networks)' networks)"
				di "{hline 20}"
				forvalues  i = 1/`r(networks)' {
					local onename : word `i' of `r(nets)'
					di "      {res}`onename'"
				}
			}
		}
		else {
			di "{txt}(0 networks)"
			di "{hline 20}"
			exit
		}
	}
	
	// set a new network
	else {
		if "`name'" == "" {
			local name "network"
		}
		
		nw_validate `name'
		if "`r(exists)'"=="true" {
			di "{txt}Warning! Switched to netname {res}`r(validname)'{txt} because {res}`name'{txt} already in use."
		}
		local name = r(validname)

		local directed = "true"
		if "`undirected'" != "" {
			local directed = "false"
		}
		
		// set network from varlist
		if ("`varlist'" != "") {
			mata: __nwnew = check_bipartite(st_data(.,"`varlist'"), "`bipartite'")
		}
		
		// set network from mata matrix
		if ("`mat'" != "") {
			mata: __nwnew = check_bipartite(`mat',"`bipartite'")  
		}
		
		// generate nodenames if not specified
		if "`labs'" == "" {
			mata: __nwnodenames = (J(rows(__nwnew),1,"`cDftNodepref'") + strofreal((1::rows(__nwnew))))'
		}
		else {
			mata: __nwnodenames = tokens(`"`labs'"')
		}
		
		// increase observation number of neccessary to match network nodes
		//if (`__nwsize' > _N){
		//	set obs `__nwsize'
		//}
		/*capture confirm variable `nw_nodename'
		mata: st_local("__nwsize", strofreal(cols(__nwnodenames)))
		qui if _rc != 0 {
			mata: st_addvar("str40", "`nw_nodename'")
			mata: st_sstore((1, cols(__nwnodenames)), "`nw_nodename'", __nwnodenames')
			order `nw_nodename', first

		}*/
		
		mata: st_rclear()
		mata: st_numscalar("r(networks)", `nws'.get_number())
		mata: st_global("r(names)", `nws'.get_names())
		//mata: st_numscalar("r(max_nodes)", `nws'.get_max_nodes())
		// generate a new network and add it
		mata: `nws'.add("`name'")
		
		if "`labsfromvar'" != "" {
			capture mata: __nwnodenames = J(rows(__nwnew),0,"`cDftNodepef'") + strofreal((1::rows(__nwnew)))
		}
		
		nw_syntax `name'
		mata: `netobj'->create_by_name(__nwnodenames)
		mata: `netobj'->set_name("`name'")
		mata: `netobj'->set_directed("`directed'")
		mata: `netobj'->set_edge(__nwnew)
	}
	capture mata: mata drop  __nwnew __nwnodenames
end

capture mata: mata drop check_bipartite()
capture mata: mata drop get_2mode_edge()
mata:
real matrix get_2mode_edge(real matrix edge){
	real scalar r, c, n
	real matrix edge2
	
	r = rows(edge)
	c = cols(edge)
	n = r + c
	
	edge2 = J(n,n, .)
	edge2[((c + 1)::n), (1::c)]= edge
	edge2[(1::c),((c+1)::n)] = edge'
	return(edge2)
}


real matrix check_bipartite(real matrix edge, string scalar bip){
	real scalar m
	
	if (bip == "bipartite"){
		edge = get_2mode_edge(edge)
	}
	else {
		m = min((rows(edge), cols(edge)))
		edge = edge[(1::m),(1::m)]
	}
	return(edge)
}
end
