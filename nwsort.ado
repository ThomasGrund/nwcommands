*! Date        : 5feb2015
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwsort
program nwsort
	version 9.0
	syntax [anything(name=netname)], by(varlist) [  ATTributes(varlist) xvars stable ]
	
	local attribute_full `attributes' `by'
	local attribute : list uniq attribute_full
		
	_nwsyntax `netname', max(1)
	local id = `id'
	
	preserve
	qui nwload `netname', labelonly	
	qui drop if _n > `nodes'
	qui gen _running = _n

	qui if "`attribute'" != "" {
		putmata `attribute',  replace
	}
	sort `by', `stable'
	qui putmata permutationVec = _running, replace
	qui nwname `netname', newlabsfromvar(_nodelab)
	restore

	mata: nw_mata`id' =  nw_mata`id'[permutationVec,permutationVec]
	
	foreach oneatt in `attribute' {
		mata: `oneatt' = `oneatt'[permutationVec]
		mata: st_store((1::`nodes'),"`oneatt'", `oneatt')
		capture mata: mata drop `oneatt'
	}
	
	if "`xvars'" == "" {
		nwload `netname'
	}
	capture mata: mata drop permutationVec
end
