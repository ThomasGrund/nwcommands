*! Date        : 15nov2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop _nwnodeid
program _nwnodeid
	syntax [anything(name=netname)], nodelab(string) [detail]
	_nwsyntax `netname'
	
	mata: st_rclear()
	mata: st_global("r(netname)", "`netname'")
	mata: st_global("r(nodelab)", "`nodelab'")
	
	capture confirm integer number `nodelab'
	if _rc == 0 {
		if `nodelab' > `nodes' {
			
			mata: st_numscalar("r(nodeid)", -1)
			di "{err}{it:nodelab} {bf:`nodelab'} out of bounds"
			error 600021
		}
		mata: st_numscalar("r(nodeid)", `nodelab')
		exit
	}
	else {
		nwname `netname'
		local labs "`r(labs)'"
		mata: st_rclear()
		mata: st_global("r(netname)", "`netname'")
		mata: st_global("r(nodelab)", "`nodelab'")
		local i = 1
		local found = 0
		 capture foreach onelab in `labs' {
			noi if "`onelab'" == "`nodelab'"{
				mata: st_numscalar("r(nodeid)", `i')
				local found = 1
				di
				if "`detail'" == "detail" {
					di "{hline 40}"
					di "{txt}  Network: {res}`netname'"
					di "{hline 40}"
					di "{txt}    Nodeid  : {res}`r(nodeid)'"
					di "{txt}    Nodelab : {res}`r(nodelab)'"
				}
				exit 1
			}
			local i = `i' + 1
		}
		if `found' == 0 {
			mata: st_numscalar("r(nodeid)", -1)
			di "{err}{it:nodelab} `nodelab' not found"
			error 6012
		}
	}
end
