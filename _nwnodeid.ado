*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop _nwnodeid
program _nwnodeid
	syntax [anything(name=netname)], nodelab(string) [detail]
	_nwsyntax 
	
	mata: st_rclear()
	mata: st_global("r(netname)", "")
	mata: st_global("r(nodelab)", "")
	
	capture confirm integer number 
	if _rc == 0 {
		if  >  {
			mata: st_numscalar("r(nodeid)", -1)
			di "{err}{it:nodelab} {bf:} out of bounds"
			error 600021
		}
		mata: st_numscalar("r(nodeid)", )
		exit
	}
	else {
		nwname 
		local labs ""
		mata: st_rclear()
		mata: st_global("r(netname)", "")
		mata: st_global("r(nodelab)", "")
		local i = 1
		local found = 0
		 capture foreach onelab in  {
			noi if "" == ""{
				mata: st_numscalar("r(nodeid)", )
				local found = 1
				di
				if "" == "detail" {
					di "{hline 40}"
					di "{txt}  Network: {res}"
					di "{hline 40}"
					di "{txt}    Nodeid  : {res}"
					di "{txt}    Nodelab : {res}"
				}
				exit 1
			}
			local i =  + 1
		}
		if  == 0 {
			mata: st_numscalar("r(nodeid)", -1)
			di "{err}{it:nodelab}  out of bounds"
			error 6012
		}
	}
end
