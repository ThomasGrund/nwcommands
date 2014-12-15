capture program drop nwkatz
program nwkatz
	version 9
	syntax [anything(name=netname)] , alpha(real) [nosym GENerate(string) unconnected(integer 0)]
	_nwsyntax `netname', max(9999)
	_nwsetobs `netname'

	if `networks' > 1 {
		local k = 1
	}
	
	if "`generate'" == "" {
		local generate = "_katz"
	}
	
	qui foreach netname_temp in `netname' {
		nwname `netname_temp'
		local directed = r(directed)
		mata: katz = J(`nodes', `nodes', `alpha')	
		tempname geo dist
		nwgeodesic `netname_temp', `nosym' name(`geo') unconnected(`unconnected')
		nwtomata `geo', mat(`dist')
		mata: katz =  katz :^ `dist'
		mata: katz_out = (colsum(katz))'
		mata: katz_in = (rowsum(katz))
		
		if "`directed'" == "true"{
			capture drop `generate'_out`k'
			capture drop `generate'_in`k'
			nwtostata, mat(katz_out) gen(`generate'_out`k')
			nwtostata, mat(katz_in) gen(`generate'_in`k')
		}
		else {
			capture drop `generate'`k'
			nwtostata, mat(katz_out) gen(`generate'`k')
		}
		capture nwdrop `geo'
		
		local k = `k' + 1
	}
end
