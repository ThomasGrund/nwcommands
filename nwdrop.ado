*! Date        : 26oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwdrop
program nwdrop
	version 9
	syntax [anything(name=netname)] [if] [in]
	unw_defs
	nw_syntax `netname', max(9999)

	if "`if'" == "" & "`in'" == "" {
		foreach netname_temp in `netname' {
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
		tempname drop
		qui gen `ifcond' = 1 `if' `in'
		mata: `drop' = (st_data((1::`nodes'),"`ifcond'"))'
		mata: _editmissing(`drop', 0)
		mata: `netobj'->drop_nodes(`drop')
		mata: mata drop `drop'
	}
	mata: st_rclear()
end


