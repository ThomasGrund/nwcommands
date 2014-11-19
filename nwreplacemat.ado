*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwreplacemat
program nwreplacemat
	version 9.0
	syntax anything(name=netname), newmat(string) [vars(string) labs(string) nosync netonly]
	_nwsyntax , max(1)
	
	mata: st_numscalar("r(matrows)", rows())
	mata: st_numscalar("r(matcols)", cols())
	local matrows = r(matrows)
	local matcols = r(matcols)
	
	// newmat is invalid (not N x X matrix)
	if ( != ){
		di "{err}input matrix has invalid dimensions"
		erorr 6082
	}
	
	// newmat is of different size than the network
	if ( != ){
		//di "{txt}input matrix has different dimensions than existing {it:network} {bf:}. size of {bf:} has been adjusted."
		local nodes = 
		
		if "" != "" {
			mata: 
			mata: nw_mata = 
			global nwsize_ = 
			if "" != "" {
				global nw_ ""
			}
			if "" != "" {
				global nwlabs_ ""
			}
		}
		else {
			nwdrop , 
			nwrandom , prob(1) name() vars() labs()
			nwreplacemat , newmat()  
			// delete empty observations in Stata
			nwcompressobs
		}
	}
	else {
		mata: nw_mata = 
		if "" == "" {
			if "" == "" {
				nwsync 
			}
		}
	}
	
	// check for directed/undirected of new network and adjust if necessary
	mata: st_numscalar("r(directed)", (issymmetric() == 1))
	
	if ( == 1) {
		global nwdirected_ = "false"
	}
	else {
		global nwdirected_ = "true"
	}
end
