*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop _nwnodelab
program _nwnodelab
	syntax [anything(name=netname)], nodeid(integer) [detail]
	_nwsyntax 

	if  >  {
		mata: st_rclear()
		di "{err}{it:nodeid} {bf:} out of bounds"
		error 600022
	}
	else {
		local onelab : word  of 
	}
	mata: st_rclear()
	mata: st_numscalar("r(nodeid)", )
	mata: st_global("r(nodelab)", "")
	mata: st_global("r(netname)", "")
	di
	if "" == "detail" {
	    di "{hline 40}"
		di "{txt}  Network: {res}"
		di "{hline 40}"
		di "{txt}    Nodeid: {res}"
		di "{txt}    Nodelab: {res}"
	}
end
