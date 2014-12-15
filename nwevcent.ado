capture program drop nwevcent
program nwevcent
	version 9
	syntax [anything(name=netname)] , [nosym GENerate(string)]
	_nwsyntax `netname', max(9999)
	_nwsetobs `netname'
	
	if `networks' > 1 {
		local k = 1
	}
	
	if "`generate'" == "" {
		local generate = "_evcent"
	}
	
	qui foreach netname_temp in `netname' {
		tempvar _comp
		nwcomponents `netname_temp', generate(`_comp')
		if (r(components) == 1) {
			nwtomata `netname_temp', mat(evnet)
			tempvar _deg _out _in _isol
			nwdegree `netname_temp', isolates generate (`_deg' `_isol')

			capture drop `generate'`k'
			if "`sym'" == "" {
				mata: evnet = (evnet + evnet')
				mata: evnet = evnet:/ evnet
				mata: _editmissing(evnet,0)
			}
			mata: e = evcentrality(evnet)
			nwtostata, mat(e) gen(`generate'`k')
			replace `generate'`k'= . if `_isol'==1
			mata: mata drop evnet e
		}
		else {
			gen `generate'`k' = .
		}
		local k = `k' + 1
	}
	mata: st_rclear()
end

capture mata: mata drop evcentrality()
mata:
real matrix function evcentrality(real matrix M)
{
	symeigensystem(M, EC=.,EV=.)
	maxEV = abs(max(EV))
	
	for(i=1;i<=rows(M);i++){
		if (abs(EV[1,i]) == abs(maxEV)){
			index = i
			break
		}
	}
	return(EC[.,index]*(-1))
}
end

