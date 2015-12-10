capture program drop nwbridge
program nwbridge
	syntax [anything(name=netname)] [, xvars generate(string) detail local global]
	_nwsyntax `netname'
	
	nwname `netname'
	local directed = "`r(directed)'"
	if "`r(directed)'" == "false" {
		local undirected "undirected"
	}
	
	nwtomata `netname', mat(onenet)
	mata: bridges = getbridges(onenet)
	mata: num_bridges = sum(bridges:== -1)
	mata: lcbridge = bridges
	mata: _editvalue(lcbridge, 2, -1)
	mata: glbridge = (bridges :== -1)
	mata: num_lcbridges = sum(lcbridge:>=3)

	if "`undirected'" != "" {
		mata: st_numscalar("r(bridges)", num_bridges / 2)
		mata: st_numscalar("r(local_bridges)", num_lcbridges / 2)
	}
	else {
		mata: st_numscalar("r(bridges)", num_bridges)
		mata: st_numscalar("r(local_bridges)", num_lcbridges)
	}
	mata: st_global("r(name)", "`netname'")
	mata: st_global("r(directed)", "`directed'")
	di ""
	di "{hline 30}"
	di "{txt}    Network      : {res}`netname'"
	di "{txt}    Directed     : {res}`directed'"
	di "{txt}    Bridges      : {res}`r(bridges)'"
	di "{txt}    Local bridges: {res}`r(local_bridges)'"
	di "{hline 30}"
	if "`generate'" != "" {
		if "`local'" == "" {
			nwset, name("`generate'") `xvars' mat(glbridge) `undirected'
		}
		else {
			nwset, name("`generate'") `xvars' mat(lcbridge) `undirected'
		}
	}
	if "`detail'" != "" {
		preserve
		nwname `netname'
		local labs "`r(labs)'"
		tempname bridgetemp
		if "`generate'" == "" {
			if "`local'" == "" {
				nwset, name("`bridgetemp'") `xvars' labs("`labs'") mat(glbridge) `undirected'
			}
			else {
				nwset, name("`bridgetemp'") `xvars' labs("`labs'") mat(lcbridge) `undirected'
			}
		}
		nwtoedge 
		qui keep if `bridgetemp' > 0
		di ""
		di "{txt}       Detailed bridges" _continue
		if "`local'" == "" {
			di " (global):"
		}
		else {
			di " (local):"
			di "       Span in parenthesis"
		}
		di ""
		forvalues i = 1/`=_N' {
			local fromid = _fromid[`i']
			local toid = _toid[`i']
			local fromlab : word `fromid' of `labs'
			local tolab : word `toid' of `labs'
			local val = `bridgetemp'[`i'] 
			local sign "<=>"
			if "`directed'" == "true" {
				local sign "=>"
			}
			di "{res}        (`fromlab' `sign' `tolab')" _continue
			if "`local'" != "" {
				di"{res} (`val')"
			}
			else {
				di ""
			}
		}
		restore
		capture nwdrop `bridgetemp'
	}
	mata: mata drop bridges glbridge lcbridge num_bridges
	
end

capture mata: mata drop getbridges()
capture mata: mata drop distance()

mata: 
real matrix getbridges(real matrix net){
	
	N = rows(net)
	B = J(N,N,0)
	// run through all nodes
	for(i = 1; i<=N; i++){
		//obtain network neighbors q
		neighbors = select((1::N)', net[i,.])
		// run through network neighbors
		for(q = 1; q<= cols(neighbors); q ++){
			j = neighbors[q]
			net_minus = net
			net_minus[i,j] = 0
			B[i,j] = distance(i,j,net_minus)
		}
	}
	return(B)
}

real scalar distance(real scalar i, real scalar j, real matrix net){
	P = net
	if (P[i,j] != 0) {
		return(1)
	}
	else {
		for(k=2; k <= rows(net); k++){
			P = P * net
			if (P[i,j] != 0) {
				return(k)
			}
		}
	}
	return(-1)
}
end
