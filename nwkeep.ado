*! Date        : 15sept2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwkeep 
program nwkeep
	syntax [anything(name=netname)][if/] [in/],[ attributes(varlist)]
	
	_nwsyntax `netname', max(9999)
	local nets `networks'
	local keepnets = "`netname'"

	_nwsyntax _all, max(9999)
	local netname : list netname - keepnets

	if "`if'" == "" & "`in'" == "" & "`netname'" != ""{
		nwdrop `netname', attributes(`attributes')
		nwcompressobs
	}
    else {
		local netname "`keepnets'"

		foreach keepnet in `keepnets' {
			nwname `keepnet'
			local id = r(id)
			local nodes = r(nodes)
			local z = `z' + 1
		
			if ("`if'" != "" | "`in'" != ""){
				tempvar keepnode
				gen `keepnode' = 0
				if "`if'" != "" {
					replace `keepnode' = 1 if `if'
				}
				if "`in'" != "" {
					replace `keepnode' = 1 in `in'
				}
			
				mata: keepnode = st_data((1,`nodes'), st_varindex("`keepnode'"))
			
				if (`z' != `nets') {
					nwkeepnodes `keepnet', keepmat(keepnode) `netonly'
				}
				else {
					nwkeepnodes `keepnet', keepmat(keepnode) `netonly' attributes(`attributes')
				}
				mata: mata drop keepnode
			}
		}
	}
end
	
