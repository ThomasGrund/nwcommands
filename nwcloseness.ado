*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwcloseness
program nwcloseness
	version 9
	syntax [anything(name=netname)] [, GENerate(string)]	
	_nwsyntax , max(9999)
	if  > 1 {
		local k = 1
	}
	
	local gencount : word count 
	if ( != 3) {
		local generate = "_closeness _farness _nearness"
	}
	
	foreach netname_temp in  {
		qui nwgeodesic , name(_tempgeodesic) 
		nwname _tempgeodesic
		nwtomata _tempgeodesic, mat(geodesic)
		mata: far = rowsum(geodesic)
		
		_nwsyntax_other 
		
		mata: nearness = J(, 1,1) :/ far
		mata: closeness = nearness :* ( - 1)
		local _closeness : word 1 of 
		local _farness : word 2 of 
		local _nearness : word 3 of 
	
		qui capture drop 
		qui gen  = .
		qui capture drop 
		qui gen  = .
		qui capture drop 
		qui gen  =.
	
		if _N < =  {
			set obs 
		}

		mata: st_store((1::),"",closeness)
		mata: st_store((1::),"",far)
		mata: st_store((1::),"",nearness)
	
		mata: mata drop closeness far nearness geodesic
		nwdrop _tempgeodesic
		
		local k =  + 1
	}
end
