*! Date        : 26oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nw_syntax
program nw_syntax
	syntax [anything],[max(integer 1) min(passthru) nocurrent name(string)]
	unw_defs

	if "`name'" == "" {
		local name = "netname"
	}
	
	local networks_count = 1
	if "`anything'" == ""  & "`current'" == ""{
		capture mata: st_local("_temp", `nws'.get_current_name())
		capture mata: st_numscalar("r(id)",`nws'.get_index_of_current())
	}
	else {
		capture nwunab _temp : `anything', max(`max') `min'
		local networks_count : word count `_temp'
		capture local lastnet : word `networks_count' of `_temp'
		mata: st_numscalar("r(id)", first_index_match(`nws'.names, "`lastnet'"))
	}
	
	if _rc != 0 {
		di "{err}Network not found"
	    error `errNWsNotFound'
	}

	mata: st_local("directed", `nws'.pdefs[`r(id)']->is_directed())
	mata: st_local("nodes", strofreal(`nws'.pdefs[`r(id)']->get_nodes()))
	mata: st_local("selfloops", `nws'.pdefs[`r(id)']->is_selfloop())
	
	c_local selfloops "`selfloops'"
	c_local nodes "`nodes'"
	c_local directed "`directed'"
	c_local netobj "`nws'.pdefs[`r(id)']"
	c_local id `r(id)'
	c_local netname `_temp'
	c_local networks `networks_count'	
end
