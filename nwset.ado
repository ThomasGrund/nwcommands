*! Date        : 13oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwset	
program nwset
syntax [varlist (default=none)][, overwrite bipartite selfloop labs(string) keeporiginal xvars clear nwclear nooutput edgelist name(string) labsfromvar(string) edgelabs(string asis) detail mat(string) undirected directed]
	set more off
	unw_defs

	capture mata: `nw'
	if (_rc != 0) {
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
			mata: st_numscalar("r(networks)", 0)
			mata: st_global("r(nets)", "")	
			exit
		}
	}
	
	// set a new network
	else {
		tempname __nwnew
		tempname __nwnodenames
		if "`name'" == "" {
			local name "network"
		}
		
		nw_validate `name'
		if "`r(exists)'"=="true" {
			di "{txt}Warning! Switched to netname {res}`r(validname)'{txt} because {res}`name'{txt} already in use."
		}
		local name = r(validname)

		// set network from varlist
		if ("`varlist'" != "") {
			mata: `__nwnew' = check_bipartite(st_data(.,"`varlist'"), "`bipartite'")
		}
		
		// set network from mata matrix
		if ("`mat'" != "") {
			mata: `__nwnew' = check_bipartite(`mat',"`bipartite'")  
		}
		
		// generate nodenames if not specified
		if "`labs'" == "" & "`labsfromvar'" == "" {
			mata: `__nwnodenames' = (J(rows(`__nwnew'),1,"`cDftNodepref'") + get_node_suffix(rows(`__nwnew')))'
		}
		if "`labs'" != ""  {
			mata: `__nwnodenames' = (get_nodenames_from_string(`"`labs'"', rows(`__nwnew'),"`cDftNodepref'"))'
		}
		if "`labsfromvar'" != "" {
			mata: `__nwnodenames' = (st_sdata(.,"`labsfromvar'"))'
			if("`varlist'" != "" & "`bipartite'" != ""){
				mata: `__nwnodenames' = (tokens("`varlist'"),`__nwnodenames')
			}
			if("`varlist'" != "" & "`bipartite'" == ""){
				mata: `__nwnodenames' = `__nwnodenames'[(1::rows(`__nwnew'))] 
			}
			if("`mat'" != "") {
				mata: `__nwnodenames' = (J(rows(`__nwnew'),1,"`cDftNodepref'") + get_node_suffix(rows(`__nwnew')))'
			}
		}
		
		mata: st_rclear()
		mata: st_numscalar("r(networks)", `nws'.get_number())
		mata: st_global("r(names)", `nws'.get_names())
		mata: `nws'.add("`name'")
		
		if "`labsfromvar'" != "" {
			capture mata: `__nwnodenames' = J(rows(`__nwnew'),0,"`cDftNodepef'") + strofreal((1::rows(__nwnew)))
		}
		
		nw_syntax `name'
		mata: `netobj'->create_by_name(`__nwnodenames')
		mata: `netobj'->set_name("`name'")
		mata: `netobj'->set_directed("`undirected'" == "")
		mata: `netobj'->set_selfloop("`selfloop'" == "selfloop")
		mata: `netobj'->set_edge(`__nwnew')
		mata: st_numscalar("foundselfloops", (sum(diagonal(`__nwnew'))>0))
		if (foundselfloops == 1){
			mata: `netobj'->set_selfloop(1)
		}
		
		if "`undirected'" != "" {
			nwsym `name'
		}
	}
	capture mata: mata drop `__nwnew' 
	capture mata: mata drop `__nwnodenames'
end

capture mata: mata drop check_bipartite()
capture mata: mata drop get_2mode_edge()
capture mata: mata drop get_node_suffix()
capture mata: mata drop get_nodenames_from_string()
capture mata: mata drop get_nodenames_from_var()

mata:
string matrix get_nodenames_from_var(string scalar v, real scalar z, string scalar def){
	string scalar s 
	
	s = invtokens(st_sdata((1,z), v))
	return(get_nodenames_from_string(s, z, def))
}

string matrix get_nodenames_from_string(string scalar s, real scalar z, string scalar def){
	string matrix nodenames, nodenamesrest
	real scalar invalid, i, j
	
	nodenames = (tokens(s,","))'
	nodenames = select(nodenames, (J(rows(nodenames),1, ","):!= nodenames)) 
	invalid = 0
	
	// check for duplicates
	for (i = 1; i<= (rows(nodenames)-1); i++){
		for (j = i + 1; j <= rows(nodenames); j++){
			if (nodenames[i] == nodenames[j]){
				invalid = 1
				i = rows(nodenames) + 1
				j = rows(nodenames) + 1
			}
		}
	}
	
	if (invalid == 1){
		nodenames =(J(z,1,def) + get_node_suffix(z))
		return(nodenames)
	}
	
	if (rows(nodenames)< z){
		nodenamesrest = (J(z,1,def) + get_node_suffix(z))
		printf("{txt}Warning! Not enough node labels specified.")
		nodenamesrest[(1::rows(nodenames))] = nodenames	
		return(nodenamesrest)
	}
	if (rows(nodenames)> z){
		printf("{txt}Warning! Too many node labels specified.")
		return(nodenames[(1::z)])
	}
	return(nodenames)	
}

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

string matrix get_node_suffix(real scalar nodes){
	real matrix M
	string matrix S
	real scalar i
	
	M = (1::nodes)
	S = strofreal(M)
	for (i = 10; i <= nodes; i = i * 10) {
		//S[(1::(i -1))] = J((i -1),1,"0") + S[(1::(i-1))]
	}
	return(S)
}
end
