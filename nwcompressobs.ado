*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwcompressobs
program nwcompressobs
	tempvar allmissing
	tempvar temp
	
	qui gen  = .
	qui foreach var of varlist _all {
		capture encode , gen()
		if (_rc == 0){
			replace  = 0 if  != .
			drop 
		}
		else {
			replace  = 0 if  != .
		}
	}
	qui drop if ( == .)
end
