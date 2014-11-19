*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwtab
program nwtab
	syntax [anything(name=something)] [, twoway *]
	
	local c : word count 
	if  > 2 {
		di "{err}Only two networks or one network and one attribute can be used."
		exit
	}

	local n1: word 1 of 
	local n2: word 2 of 
	
	// check for variable input
	capture confirm variable 
	if (_rc == 0 | "" != "" |  == 2) {
		nwtab2 , 
	}
	else {	
		nwtab1 , 
	}
end
