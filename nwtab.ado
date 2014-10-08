capture program drop nwtab
program nwtab
	syntax [anything(name=something)] [, oneway *]
	
	local c : word count `something'
	if `c' > 2 {
		di "{err}Only two networks or one network and one attribute can be used."
		exit
	}

	local n1: word 1 of `something'
	local n2: word 2 of `something'
	
		
	if ("`oneway'" != "" | (`c' == 0)) {
		nwtab1 `something', `options'
	}
	else {
		nwtab2 `something', `options'
	}
end
