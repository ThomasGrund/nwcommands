*! Date        : 26oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwkeep
program nwkeep
	syntax [anything(name=netname)] [if] [in]
	unw_defs
	nw_syntax `netname', max(9999)
	local keeplist `netname'
	
	qui nwset
	local alllist `r(nets)'
	local droplist : list alllist - keeplist
	
	if "`if'" == "" & "`in'" == "" {
		foreach netname_temp in `droplist' {
			mata: `nws'.drop("`netname_temp'")
		}
		qui nwset
		if r(networks) == 0 {
			capture mata: mata drop `nw'
		}
	}
	else {
		nw_syntax `netname', max(1)
		local n `nodes'
		nw_datasync `netname'
		
		tempvar ifcond
		tempname keep
		qui gen `ifcond' = 1 `if' `in'
		mata: `keep' = (st_data((1::`nodes'),"`ifcond'"))'
		mata: _editmissing(`keep', 0)
		mata: `netobj'->keep_nodes(`keep')
		mata: mata drop `keep'
	}
	mata: st_rclear()
end
