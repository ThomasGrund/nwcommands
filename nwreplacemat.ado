capture program drop nwreplacemat
program nwreplacemat
	version 9.0
	syntax anything(name=netname), newmat(string) [vars(string) labs(string) nosync netonly xvars]
	_nwsyntax `netname', max(1)
	
	capture mat list `newmat'
	if _rc == 0 {
		mata: `newmat' = st_matrix("`newmat'")
	}
	
	mata: st_numscalar("r(matrows)", rows(`newmat'))
	mata: st_numscalar("r(matcols)", cols(`newmat'))
	local matrows = r(matrows)
	local matcols = r(matcols)
	
	// newmat is invalid (not N x X matrix)
	if (`matrows' != `matcols'){
		di "{err}input matrix has invalid dimensions"
		erorr 6082
	}
	
	// newmat is of different size than the network
	if (`matrows' != `nodes'){
		//di "{txt}input matrix has different dimensions than existing {it:network} {bf:`netname'}. size of {bf:`netname'} has been adjusted."
		local nodes = `matrows'
		
		if ("`netonly'" != "" | "`sync'" != "") {
			mata: `newmat'
			mata: nw_mata`id' = `newmat'
			global nwsize_`id' = `matrows'
			if "`vars'" != "" {
				global nw_`id' "`vars'"
			}
			if "`labs'" != "" {
				global nwlabs_`id' "`labs'"
			}
		}
		else {
			nwdrop `netname', `netonly'
			nwrandom `nodes', prob(1) name(`netname') vars(`vars') labs(`labs') `xvars'
			nwreplacemat `netname', newmat(`newmat') `nosync' `xvars'
			// delete empty observations in Stata
			nwcompressobs
		}
	}
	else {
		mata: nw_mata`id' = `newmat'
		if "`netonly'" == "" {
			if "`sync'" == "" {
				nwsync `netname'
			}
		}
	}
	
	// check for directed/undirected of new network and adjust if necessary
	mata: st_numscalar("r(directed)", (issymmetric(`newmat') == 1))
	
	if (`r(directed)' == 1) {
		global nwdirected_`id' = "false"
	}
	else {
		global nwdirected_`id' = "true"
	}
end
