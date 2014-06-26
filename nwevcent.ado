capture program drop nwevcent
program nwevcent
	version 9
	syntax [anything(name=netname)]
	_nwsyntax `netname', max(1)
	
	if (_N < `nodes'){
		set obs `nodes'
	}
	
	nwtomata `netname', mat(evnet)
	nwdegree `netname', isolates

	capture drop _evcent
	gen _evcent = .
	mata: evnet = (evnet + evnet')
	mata: evnet = evnet:/ evnet
	mata: _editmissing(evnet,0)
	mata: e = evcentrality(evnet)
	mata: st_store((1::`nodes'),"_evcent",e)
	replace _evcent= . if _isolates==1
	drop _isolates
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

