capture program drop nwevcent
program nwevcent
	version 9
	syntax [anything(name=netname)] , [GENerate(string)]
	_nwsyntax `netname', max(1)
	
	if (_N < `nodes'){
		set obs `nodes'
	}
	
	nwtomata `netname', mat(evnet)
	tempvar _isol
	qui nwdegree `netname', isolates generate(`_isol')
	if "`generate'" == "" {
		local generate = "evcent"
	}
	capture drop `generate'
	gen `generate' = .
	mata: evnet = (evnet + evnet')
	mata: evnet = evnet:/ evnet
	mata: _editmissing(evnet,0)
	mata: e = evcentrality(evnet)
	mata: st_store((1::`nodes'),"`generate'",e)
	replace `generate'= . if _isolates==1
	mata: mata drop evnet e
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

