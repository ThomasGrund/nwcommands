capture program drop nwtab
program nwtab
	syntax [anything(name=something)] [, twoway *]
	
	local c : word count `something'
	if `c' > 2 {
		di "{err}Only two networks or one network and one attribute can be used."
		exit
	}

	local n1: word 1 of `something'
	local n2: word 2 of `something'
	
	// check for variable input
	capture confirm variable `something'
	if (_rc == 0 | "`twoway'" != "" | `c' == 2) {
		nwtab2 `something', `options'
	}
	else {	
		nwtab1 `something', `options'
	}
end
