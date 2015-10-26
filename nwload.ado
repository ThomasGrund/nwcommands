*! Date        : 23oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwload
program nwload
	syntax [anything(name=netname)][, xvars labelonly force]
	unw_defs
	nw_syntax `netname', max(1)
	nwname `netname'

	if (`r(nodes)' > 1000 & "`force'"=="") {
		local labelonly "labelonly"
	}
	
	if (`=`c(k)' + `r(nodes)'' >= `c(max_k_theory)'  & "`force'"=="") {
		local labelonly "labelonly"
	}
	
	if (`r(nodes)' > 1000 & "`force'" == "" & "`labelonly'" == "") {
		exit
	}
	
	if (`=`c(k)' + `r(nodes)'' >= `c(max_k_theory)' & "`force'" == "" & "`labelonly'" == "") {
		exit
	}

	// drop the variables used for the current network
	mata: `nws'.drop_current_nodesvar()
	
	// make network the current network
	mata: `nws'.make_current_from_name("`netname'")
	nw_datasync `netname'
	
	if "`labelonly'" == "" {		
		mata: `nws'.generate_current_nodesvar()
		nw_syntax `netname'
		mata: st_store((1::(`netobj'->get_nodes())),`netobj'->nodesvar,(`netobj'->get_edge())) 
		order `nw_nodename' 
	}
end

capture mata: mata drop get_string_from_vector()
mata:
string scalar get_string_from_vector(string rowvector v){
	real scalar i
	string scalar s
	
	for(i = 1; i<= cols(v); i++){
		s = s + " " + v[i]
	}
	return(s)
}
end

