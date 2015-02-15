*! Date        : 15sept2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwpath
program nwpath
	version 9
	syntax [anything(name=netname)], ego(string) alter(string)[sym generate(string) _paths(string) _geodesic(string) length(string) name(string) xvars ]
	
	set more off
	if "`length'" == "" {
		local length 0
	}
	
	_nwsyntax `netname', max(1)
	nwname `netname'
	local labs "`r(labs)'"
	mata: st_rclear()
	
	local uselab = 1
	capture confirm integer number `ego'
	if _rc == 0 {
		local uselab = 0
	}
	
	qui _nwnodeid `netname', nodelab(`ego')
	local ego = r(nodeid)
	qui _nwnodeid `netname', nodelab(`alter')
	local alter = r(nodeid)
	qui _nwnodelab `netname', nodeid(`ego')
	local ego_lab = r(nodelab)
	qui _nwnodelab `netname', nodeid(`alter')
	local alter_lab = r(nodelab)
	
	qui if "`_geodesic'" == "" {
		if "`sym'" == ""{
			nwgeodesic `netname', nosym unconnected(-1) xvars name(_temp_geodesic)
		}
		else {
			nwgeodesic `netname', unconnected(-1) xvars name(_temp_geodesic)
		}
		qui nwvalue _temp_geodesic[`ego',`alter']
		local shortestpath = r(value)
		nwdrop _temp_geodesic
	}
	// distance matrix is given
	else {
		mata: st_numscalar("r(path_shortest)", `_geodesic'[`ego', `alter'])
		local shortestpath = r(path_shortest)
	}
	
	if `shortestpath' == -1 {
		di "{err}no valid path exists from node {bf:`ego'} to node {bf:`alter'}."
		mata: st_numscalar("r(path_shortest)", -1)
		mata: st_numscalar("r(paths)", 0)
		mata: st_numscalar("r(ego)", `ego')
		mata: st_numscalar("r(alter)", `alter')
		mata: st_global("r(ego_lab)", "`ego_lab'")
		mata: st_global("r(alter_lab)", "`alter_lab'")
		error 6299
	}
	
	nwtomata `netname', mat(netpath)
	if "`sym'" != "" {
		mata: netpath = netpath :+ netpath'
	}
	mata: netpath = netpath :/ netpath
	mata: _editmissing(netpath, 0)

	mata: path = getpath(netpath, `ego', `alter', `length')
	mata: st_numscalar("r(paths)", rows(path))
	if `length' == 0 {
		local length = `shortestpath'
	}
	mata: st_numscalar("r(path_length)", `length')
	local path_nets `r(paths)' 
	
	if "`generate'" != "" {
		forvalues i=1/`path_nets'{
			local pname "`generate'"
			if (`path_nets' > 1) {
				local pname "`pname'_`i'"
			}
			mata: newpath = makenet(path, `i', `nodes')
			nwset, name(`pname') mat(newpath) vars(`vars')
		}
	}
	
	if "`_paths'" != "" {
		mata: `_paths' = path
	}
	
	mata: st_matrix("r(paths_matrix)", path)
	mata: st_numscalar("r(paths)", rows(path))
	mata: st_numscalar("r(path_length)", `length')
	mata: st_numscalar("r(path_shortest)", `shortestpath')
	mata: st_numscalar("r(ego)", `ego')
	mata: st_numscalar("r(alter)", `alter')
	mata: st_global("r(ego_lab)", "`ego_lab'")
	mata: st_global("r(alter_lab)", "`alter_lab'")
	di ""
	di "{hline 40}"
	di "{txt}  Network: {res}`netname'"
	di "{hline 40}"
	di "{txt}    Ego                  : {res}`ego' (`ego_lab')"
	di "{txt}    Alter                : {res}`alter' (`alter_lab')"
	di "{txt}    Shortest path length : {res}`r(path_shortest)'"
	di "{txt}    Selected length      : {res}`r(path_length)'"
	di "{hline 40}"
	capture matrix temp_mat = r(paths_matrix)
	capture local temp_rows = rowsof(r(paths_matrix))
	if _rc != 0 {
		local temp_rows = 0
	}
	capture local temp_cols = colsof(r(paths_matrix))
	capture forvalues i = 1/`temp_rows' {
		noi di ""
		noi di "{txt}  Path `i': " _continue
		forvalues j = 1/`temp_cols' {
			local temp =  temp_mat[`i',`j']
			local onelab : word `temp' of `labs'
			if `uselab' == 1 {
				noi di " {res}`onelab'" _continue
			}
			else {
				noi di " {res}`temp'" _continue
			}
			if `j' < `temp_cols' {
				noi di "{txt} =>" _continue
			}
		}
	}
	di ""
	capture mata: mata drop path 
	capture mata: mata drop netpath
end


capture mata mata drop getpath()
capture mata mata drop makenet()

mata:
real matrix makenet(real matrix path,  real scalar id, real scalar nodes){
	net = J(nodes, nodes, 0)
	for (i = 1; i < cols(path); i++){
		ego = path[id, i]
		alter = path[id, (i + 1)]
		net[ego, alter] = 1
	}
	return(net)
}

real matrix getpath(real matrix nw, real scalar ego, real scalar alter, real scalar length)
{
	real scalar found, step, temp, temp_new
	real matrix ids, paths_new, paths_sofar, paths_valid
	//, paths_new, paths_valid, path_temp, paths_sofar, path_next, 
	
	found = 0
	nodes = rows(nw)
	ids = (1::nodes)
	paths_sofar = J(1,1,ego)
	step = 0
	

	while (found == 0 & step <= nodes) {
		new_paths = 0
		step = step + 1
		for (i = 1; i<= rows(paths_sofar); i ++) {
			id_next = paths_sofar[i, step]
			reach_next = (nw[id_next,])'
			if (length != 0) {
				if (step == length){
					found = 1
				}
			}
			else if (reach_next[alter,1] != 0) {
				found = 1
			}
			new_paths = new_paths + sum(reach_next)
		}
		
		paths_new = J(new_paths, (step + 1),0)
		temp = 1
		if (rows(paths_new)> 0) {
		  for (i = 1; i<= rows(paths_sofar); i ++) {
			id_next = paths_sofar[i, step]
			reach_next = (nw[id_next,])'
			reach_ids = select(ids, reach_next)
			reach_num = sum(reach_next)
			if (reach_num > 0){
				path_next = J(reach_num, (step + 1),0)
				path_next[,step] = J(reach_num,1,id_next)
				path_next[,(step+1)] = reach_ids
				for (j = 1; j<step;j++){
					path_next[,j] = J(reach_num,1,paths_sofar[i,j])
				}
				new_temp = temp + (rows(path_next) - 1)
				paths_new[(temp::new_temp),] = path_next
				temp = new_temp + 1
			}
		   }
		  }
		  paths_sofar = paths_new
		
	}
	paths_valid = paths_sofar[,(step + 1)] :== alter
	paths = select(paths_sofar, paths_valid)
	return(paths)
}
end	
	
	
