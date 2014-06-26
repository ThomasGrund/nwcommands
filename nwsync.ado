capture program drop nwsync
program def nwsync
	version 9
	syntax [anything(name=netname)],[fromstata]
	
	_nwsyntax `netname', max(9999)

	nwname `netname'
	local id = r(id)
	local nodes = r(nodes)
	scalar onevars = "\$nw_`id'"
	local vars `=onevars'

	capture confirm variable `vars'
	qui if (_rc == 0){
		// sync from Stata to network
		if "`fromstata'" != "" {
			mata: _syncmat = st_data((1::`nodes'),"`vars'")
			nwreplacemat `netname', newmat(_syncmat) nosync
			mata: mata drop _syncmat
		}
		// sync from network to Stata
		else {
			nwtomata `netname', mat(_syncmat)
			local stataObs = _N
			if (`stataObs' < `nodes'){
				set obs `nodes'
			}
			local i = 1
			foreach var in `vars' {
				tempvar onecol
				gen `onecol' = .
				mata: st_store((1,`nodes'), tokens("`onecol'"), _syncmat[.,`i']) 
				replace `var' = `onecol'
				local i = `i' + 1
			}
			mata: mata drop _syncmat
		}
	}
end
