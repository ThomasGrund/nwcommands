capture program drop nwkatz
program nwkatz
	version 9
	syntax [anything(name=netname)] , alpha(real) [ GENerate(string) unconnected(integer 0)]
	_nwsyntax `netname', max(9999)
	_nwsetobs

	if `networks' > 1 {
		local k = 1
	}
	
	if "`generate'" == "" {
		local generate = "_katz"
	}
	local generate_all ""
	
	qui foreach netname_temp in `netname' {
		nwname `netname_temp'
		local directed = r(directed)
		mata: katz = J(`r(nodes)', `r(nodes)', `alpha')	
		tempname geo dist
		
		nwgeodesic `netname_temp', nosym name(`geo') unconnected(`unconnected')
		nwtomata `geo', mat(`dist')
		mata: katz =  katz :^ `dist'
		mata: katz_out = (colsum(katz))'
		mata: katz_in = (rowsum(katz))
		
		if "`directed'" == "true"{
			capture drop `generate'_out`k'
			capture drop `generate'_in`k'
			nwtostata, mat(katz_out) gen(`generate'_out`k')
			nwtostata, mat(katz_in) gen(`generate'_in`k')
			local generate_all "`generate_all' `generate'_out`k' `generate'_in`k'"
		}
		else {
			capture drop `generate'`k'
			nwtostata, mat(katz_out) gen(`generate'`k')
			local generate_all "`generate_all' `generate'`k'"
		}
		capture nwdrop `geo'
		local k = `k' + 1
	}
	mata: st_rclear()
	di "{hline 40}"
	di "{txt}  Network name: {res}`netname'"
	di "{hline 40}"
	di "{txt}    Katz centrality"
	sum `generate_all'
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
