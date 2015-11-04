*! Date        : 25oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nw_name
program nw_name
	version 9
	syntax [anything(name=netname)], [id(string) newselfloop(string) newlabs(string) newlabsfromvar(varname) newvars(string) newtitle(string) newcaption(string) newname(string) newdirected(string) ]
	
	mata: st_rclear()
	
	local nets wordcount("`netname'")
	if `nets' > 1 {
		di "{err}only one {it:netname} allowed"
		error 6055
	}
	mata: st_local("number", strofreal(nw.nws.get_number()))

	if ("`netname'" == "" & "`id'" == ""){
		local id = `number'
	}
	if "`netname'" == "" {
		mata: st_local("netname", nw.nws.pdefs[`id']->get_name())
	}
	if "`id'" == "" {
		qui nwunab nets : _all	
		local id : list posof "`netname'" in nets
		mata: st_rclear()
		if `id' == 0 {
			local id = -1
		}
	}
	
	if "`newname'" != "" {
		mata: nw.nws.rename("`netname'", "`newname'")
	}
	if "`newdirected'" != "" {
		mata: nw.nws.pdefs[`id']->set_directed("`newdirected'")
	}
	if "`newlabsfromvar'" != "" {
		mata: nw.nws.pdefs[`id']->set_nodes(st_sdata((1::(nw.nws.pdefs[`id']->get_nodes())), "`labsfromvar'"))		
	}
	if "`newtitle'" != "" {
		mata: nw.nws.pdefs[`id']->set_label("`newtitle'")
	}
	if "`newcaption'" != "" {
		mata: nw.nws.pdefs[`id']->set_caption("`newcaption'")
	}
	if "`newselfloop'" != "" {
		mata: nw.nws.pdefs[`id']->set_selfloop("`newselfloop'")
	}
	
	mata: st_numscalar("r(id)", `id')
	mata: st_global("r(netname)", nw.nws.pdefs[`id']->get_name())
	mata: st_global("r(vars)", nw.nws.pdefs[`id']->get_nodesvar())
	mata: st_numscalar("r(nodes)", nw.nws.pdefs[`id']->get_nodes())
	mata: st_global("r(mode2)", nw.nws.pdefs[`id']->is_2mode())
	mata: st_global("r(selfloop)", nw.nws.pdefs[`id']->is_selfloop())
	mata: st_numscalar("r(selfloops)", nw.nws.pdefs[`id']->get_selfloops_number())
	mata: st_global("r(directed)", nw.nws.pdefs[`id']->is_directed())
	mata: st_global("r(valued)", nw.nws.pdefs[`id']->is_valued())
	mata: st_global("r(title)", nw.nws.pdefs[`id']->get_label())
	mata: st_global("r(caption)", nw.nws.pdefs[`id']->get_caption())
	mata: st_numscalar("r(missing_edges)", nw.nws.pdefs[`id']->get_missing_edges())
	//!! Should r(labs) have real labels?	
	mata: st_global("r(labs)", invtokens(nw.nws.pdefs[`id']->get_nodenames(),","))	
end

