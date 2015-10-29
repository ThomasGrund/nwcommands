capture program drop nwsummarize
program nwsummarize
	version 9
	syntax [anything(name=netname)][, mat matonly detail save(string asis) ]
	set more off
	nw_syntax `netname', max(9999)

	
	if "`detail'" != "" {
		local add "indg_central outdg_central dg_central transitivity reciprocity"
	}
	tempname memhold
	if "`save'" != "" {
		postfile `memhold' str20 name str10 directed id nodes minval maxval edges arcs density `add' using `"`save'"', replace
	}
	foreach onenet in `netname' {
		nwinf `onenet', `mat' `matonly' `detail'
		if "`save'" != "" {
			if "`r(directed)'" == "false" {
				if "`detail'" == "" {
					post `memhold' ("`r(name)'") ("`r(directed)'") (`r(id)') (`r(nodes)') (`r(minval)') (`r(maxval)') (`r(edges)') (.) (`r(density)')
				}
				else {
					post `memhold' ("`r(name)'") ("`r(directed)'") (`r(id)') (`r(nodes)') (`r(minval)') (`r(maxval)') (`r(edges)') (.) (`r(density)') (.) (.) (`r(dg_central)') (`r(transitivity)') (`r(reciprocity)')
				}
			}
			else {
				if "`detail'" == "" {
					post `memhold' ("`r(name)'") ("`r(directed)'") (`r(id)') (`r(nodes)') (`r(minval)') (`r(maxval)') (.) (`r(arcs)') (`r(density)')
				}
				else {
					post `memhold' ("`r(name)'") ("`r(directed)'") (`r(id)') (`r(nodes)') (`r(minval)') (`r(maxval)') (.) (`r(arcs)') (`r(density)') (`r(indg_central)') (`r(outdg_central)') (.) (`r(transitivity)') (`r(reciprocity)')
				}
			}
		}
	}
	
	if "`save'" != "" {
		postclose `memhold'
	}
end
	

capture program drop nwinf
program nwinf
	version 9
	syntax [anything(name=netname)], [id(string) mat matonly detail]
	nw_syntax `netname', max(1)

	if "`detail'" != "" {
		qui nwdyads `thisname'
		local reciprocity = `r(reciprocity)'
		qui nwtriads `thisname'
		local transitivity = `r(transitivity)'
		qui nwdegree `thisname', outputoff
		if ("`localdirected'"=="false"){
			local central = `r(dg_central)'
		}
		else {
			local incentral = `r(indg_central)'
			local outcentral = `r(outdg_central)'
		}
		qui nwbetween `thisname', outputoff
		local bwcentral = `r(bw_central)'
	}
	
	mata: st_rclear()
	
	nw_name `netname'
	
	mata: st_global("r(name)", "`netname'")
	mata: st_global("r(netname)", "`netname'")
	mata: st_numscalar("r(minval)", `netobj'->get_minimum())
	mata: st_numscalar("r(maxval)", `netobj'->get_maximum())

	if (r(directed)=="false"){
		mata: st_numscalar("r(edges)", `netobj'->get_edges_count())
		mata: st_numscalar("r(edges_sum)", `netobj'->get_edges_sum())
		mata: st_numscalar("r(dg_central)", `central')
	}
	else {
		mata: st_numscalar("r(arcs)", `netobj'->get_arcs_count())
		mata: st_numscalar("r(arcs_value)", `netobj'->get_arcs_sum())
		mata: st_numscalar("r(indg_central)", `incentral')
		mata: st_numscalar("r(outdg_central)", `outcentral')
	}
	mata: st_numscalar("r(bw_central)", `bwcentral')
	mata: st_numscalar("r(density)", `netobj'->get_density())
	mata: st_numscalar("r(transitivity)", `transitivity')
	mata: st_numscalar("r(reciprocity)", `reciprocity')


	if "`matonly'" == "" {
		di "{hline 50}"
		di "{txt}   Network name: {res} `r(name)'"
		di "{txt}   Network id: {res} `r(id)'"
		di "{txt}   Directed: {res}`r(directed)'"
		di "{txt}   Nodes: {res}`r(nodes)'"
		di "{txt}   Selfloop: {res}`r(selfloop)'"
		if ("`r(selfloop)'" == "true") {
			di "{txt}    Number of selfloops: {res}`r(selfloops)'"
		}
		if (r(directed) == "false"){
			di "{txt}   Edges: {res}`r(edges)'"
		}
		if (r(directed) == "true"){
			di "{txt}   Arcs: {res}`r(arcs)'"
		}
		di "{txt}   Minimum value: {res} `r(minval)'"
		di "{txt}   Maximum value: {res} `r(maxval)'"	
		di "{txt}   Density: {res} `r(density)'"
		
		if "`detail'" != "" {
			di "{txt}   Reciprocity: {res} `r(reciprocity)'"
			di "{txt}   Transitivity: {res} `r(transitivity)'"
			di "{txt}   Betweenness centralization: {res} `r(bw_central)'"
			if (r(directed) == "false"){
				di "{txt}   Degree centralization: {res}`r(dg_central)'"
			}
			if (r(directed) == "true"){
				di "{txt}   Indegree centralization:: {res}`r(indg_central)'"
				di "{txt}   Outdegree centralization:: {res}`r(outdg_central)'"
			}
		}
	}
	
	if "`mat'`matonly'" !=""{
		mata: `netobj'->get_matrix()
	}
end
