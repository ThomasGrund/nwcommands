capture program drop nwevcent
program nwevcent
	version 9
	syntax [anything(name=netname)] , [nosym GENerate(string)]
	_nwsyntax `netname', max(9999)
	_nwsetobs
	
	if `networks' > 1 {
		local k = 1
	}
	
	if "`generate'" == "" {
		local generate = "_evcent"
	}
	local generate_all ""
	
    qui foreach netname_temp in `netname' {
		tempvar _comp
		nwcomponents `netname_temp', generate(`_comp')
		if (r(components) == 1) {
			nwtomata `netname_temp', mat(evnet)
			tempvar _deg _out _in 
			nwdegree `netname_temp', isolates generate (`_deg')

			capture drop `generate'`k'
			if "`sym'" == "" {
				mata: evnet = (evnet + evnet')
				mata: evnet = evnet:/ evnet
				mata: _editmissing(evnet,0)
			}
			mata: e = evcentrality(evnet)
			nwname `netname_temp'
			qui gen `generate'`k' = .
			mata: st_store((1::`r(nodes)'),"`generate'`k'", e)
			replace `generate'`k'= . if _isolate==1
			mata: mata drop evnet e
		}
		else {
			capture drop `generate'`k'
			gen `generate'`k' = .
		}
		local generate_all "`generate_all' `generate'`k'"
		local k = `k' + 1
	}
	mata: st_rclear()
	di "{hline 40}"
	di "{txt}  Network name: {res}`netname'"
	di "{hline 40}"
	di "{txt}    Eigenvector centrality"
	sum `generate_all'
end

capture mata: mata drop evcentrality()
mata:
real matrix function evcentrality(real matrix M)
{
	symeigensystem(M, EC=.,EV=.)
	maxEV = (max(EV))
	
	for(i=1;i<=rows(M);i++){
		if ((EV[1,i]) ==(maxEV)){
			index = i
			break
		}
	}
	if (EC[1,index] < 0) {
		return(EC[.,index]*-1)
	}
	else {
		return(EC[.,index])
	}	
}
end

