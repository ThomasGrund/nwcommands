capture program drop nwburt
program nwburt
	syntax [anything(name=netname)] [, dyadredundancy dyadconstraint]
	_nwsyntax `netname'
	
	nwtomata `netname', mat(onenet)
	mata: dr = dyadicredundancy(onenet)
	mata: dc = dyadicconstraint(onenet)
	
	if "`dyadredundancy'"  != "" {
		capture nwdrop dyadredundancy 
		nwset, name(dyadredundancy) mat(dr)
	}
	if "`dyadconstraint'"  != "" {
		capture nwdrop dyadconstraint
		nwset, name(dyadconstraint) mat(dc)
	}
	
	mata: effsize = rowsum(onenet) - rowsum(dr)
	mata: efficiency = effsize :/ rowsum(onenet)
	mata: constraint = rowsum(dc)
	mata: h = hierarchy(onenet, dc)
	getmata _effsize = effsize, replace
	getmata _efficiency = efficiency, replace
	getmata _constraint = constraint, replace
	getmata _hierarchy = h, replace
	mata: mata drop onenet effsize efficiency constraint h dr dc
end

capture mata: mata drop dyadicredundancy()
capture mata: mata drop dyadicconstraint()
capture mata: mata drop hierarchy()

mata:
real matrix hierarchy(real matrix net, real matrix dc){
	N = rowsum(net)	
	avgc = rowsum(dc) :/ N
	z = rowsum(net :* (dc :/ avgc) :* log(dc :/ avgc))
	H = z :/ (N :* log(N))
	_editmissing(H, 1)
	M = (N :== 0)
	_editvalue(M,1,.)
	H = H :+ M 
	return(H)
}

real matrix dyadicconstraint(real matrix net){
	real matrix p 
	
	p = net :/ rowsum(net)
	_editmissing(p, 0)
	p2 = p * p
	c = p + p2
	dyadcon = (net :* (c :* c))
	_editmissing(dyadcon,0)
	_diag(dyadcon, 0)
	return(dyadcon)
}

real matrix dyadicredundancy(real matrix net){
	real matrix netdich, net2, outdeg, dyadred
	netdich = (net :!= 0)
	net2 = net * net
	outdeg = rowsum(net)
	dyadred = (net :* (net2 :/ outdeg))
	_editmissing(dyadred,0)
	return(dyadred)
}
end
