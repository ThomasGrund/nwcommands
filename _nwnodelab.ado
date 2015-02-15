*! Date        : 15sept2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop _nwnodelab
program _nwnodelab
	syntax [anything(name=netname)], nodeid(integer) [detail]
	_nwsyntax `netname'
	nwname `netname'

	if `nodeid' > `nodes' {
		mata: st_rclear()
		di "{err}{it:nodeid} {bf:`nodeid'} out of bounds"
		error 600022
	}
	else {
		local onelab : word `nodeid' of `r(labs)'
	}
	mata: st_rclear()
	mata: st_numscalar("r(nodeid)", `nodeid')
	mata: st_global("r(nodelab)", "`onelab'")
	mata: st_global("r(netname)", "`netname'")
	di
	if "`detail'" == "detail" {
	    di "{hline 40}"
		di "{txt}  Network: {res}`netname'"
		di "{hline 40}"
		di "{txt}    Nodeid: {res}`nodeid'"
		di "{txt}    Nodelab: {res}`onelab'"
	}
end
