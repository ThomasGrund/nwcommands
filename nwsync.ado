*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwsync
program def nwsync
	version 9
	syntax [anything(name=netname)],[fromstata label]
	
	_nwsyntax , max(9999)

	nwname 
	local id = r(id)
	local nodes = r(nodes)
	scalar onevars = ""
	local vars marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
	local labs ""

	if "" != "" {
		if "" != "" {
			capture confirm variable _nodelab
			if _rc == 0 {
				nwname , newlabsfromvar(_nodelab)
			}
		}
		else {
			foreach lab in  {
				qui replace _nodelab = `""' in 
				local j =  + 1
			}
		}
	}
	capture confirm variable 
	qui if (_rc == 0){
		// sync from Stata to network
		if "" != "" {
			mata: _syncmat = st_data((1::),"")
			nwreplacemat , newmat(_syncmat) nosync
			mata: mata drop _syncmat
		}
		// sync from network to Stata
		else {
			nwtomata , mat(_syncmat)
			local stataObs = _N
			if ( < ){
				set obs 
			}
			local i = 1
			foreach var in  {
				tempvar onecol
				gen  = .
				mata: st_store((1,), tokens(""), _syncmat[.,]) 
				replace  = 
				local i =  + 1
			}
			mata: mata drop _syncmat
		}
	}
end
