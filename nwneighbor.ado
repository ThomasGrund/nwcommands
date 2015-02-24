*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwneighbor
program nwneighbor
	syntax [anything(name=netname)], ego(string) [ mode(string)]
	_nwsyntax `netname', max(1)
	nwname `netname'
	local labs "`r(labs)'"
	local uselab = 0
	local ego_out = "`ego'"
	
	capture confirm integer number `ego'
	if _rc != 0 {
		local uselab = 1
	}
	
	_nwnodeid `netname', nodelab(`ego')
	local ego = r(nodeid)
	_nwnodelab `netname', nodeid(`ego')
	local ego_lab = r(nodelab)
	
	if "`mode'" == "" {
		local mode = "outgoing"
	}
	_opts_oneof "incoming outgoing both" "mode" "`mode'" 6810
	
	nwtomata `netname', mat(onenet)
	_nwsyntax `netname', max(1)
	
	mata: vecin=onenet[.,`ego']
	mata: vecout=onenet[`ego',.]
	if "`mode'" == "incoming" {
		mata: vec = vecin
	}
	if "`mode'" == "outgoing" {
		mata: vec = vecout'
	}
	if "`mode'" == "both" {
		mata: vec = vecout' + vecin
	}
	mata: vec = vec :/ vec
	mata: _editmissing(vec,0)
	
	mata: neighbors=.
	mata: neighbor=.
	
	mata: ids = (1::`nodes')
	mata: sel = (vec :!= 0)
	mata: neighbors = select(ids, sel)

	mata: st_rclear()
	capture mata: neighbor=jumble(neighbors)[1]
	capture mata: st_numscalar("r(ego)", `ego')
	capture mata: st_numscalar("r(oneneighbor)", neighbor)
	capture mata: st_matrix("r(neighbors)", neighbors)
	
	di ""
	di "{hline 40}"
	di "{txt}  Network: {res}`netname'"
	di "{hline 40}"
	di "{txt}    Ego        : {res}`ego_out'"
	di "{txt}    Neighbors  : {res}" _continue
	
	matrix temp_mat = r(neighbors)
	local temp_rows = rowsof(temp_mat)
	if temp_mat[1,1] == . {
		local temp_rows = 0
	}
	
	local neighbors_list1 ""
	local neighbors_list2 ""
	forvalues j = 1/`temp_rows' {
		local temp =  temp_mat[`j',1]
		local onelab : word `temp' of `labs'
		local neighbors_list1 "`neighbors_list1' `temp'"
		local neighbors_list2 "`neighbors_list2' `onelab'"
		if `uselab' == 1{
			di "{res}`onelab'" _continue
		}
		else {
			di "{res}`temp'" _continue
		}
		if `j' < `temp_rows' {
			di "{txt} , " _continue
		}
	}
	mata: st_global("r(neighbors_list1)", "`neighbors_list1'")
	mata: st_global("r(neighbors_list2)", "`neighbors_list2'")
	di ""
	
	di "{hline 40}"

	
	mata: mata drop vec vecin vecout onenet neighbors neighbor ids sel
end


