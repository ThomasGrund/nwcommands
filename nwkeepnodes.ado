capture program drop nwkeepnodes
program nwkeepnodes 
	version 9
	syntax [anything(name=netname)] [, nodes(string) generate(passthru) attributes(passthru) *]
	
	capture numlist "`nodes'"
	if _rc == 0 {
		local nodelist = "`r(numlist)'"
	}
	else {
		local nodelist "`nodes'"
	}	
	
	_nwsyntax `netname', max(1)
	
	local newnodelist ""
	foreach onenode in `nodelist' {
		capture confirm integer number `onenode'
		if _rc != 0 {
			_nwnodeid `netname', nodelab(`onenode')
			local newnodelist "`newnodelist' `r(nodeid)'"
		}
		else {
			local newnodelist "`newnodelist' `onenode'"
		}
	}
	local nodelist "`newnodelist'"
		
	local dropnodes ""
	forvalues i = 1/`nodes' {
		local dropnodes "`dropnodes' `i'"
	}
	foreach j in `nodelist' {
		local dropnodes: subinstr local dropnodes "`j'" "", all word
		local dropnodes: subinstr local dropnodes "  " " ", all
		local dropnodes: subinstr local dropnodes `"""' "", all
	}	
	
	nwdropnodes `netname', nodes(`dropnodes') `generate' `attributes' `options'
end




