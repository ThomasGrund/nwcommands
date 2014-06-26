capture program drop nwkeepnodes
program nwkeepnodes 
	version 9
	syntax [anything(name=netname)] [, nodes(string)]
	
	qui nwset
	if "`netname'" == "" {
		nwcurrent
		local netname = r(current)
	}
	qui nwname `netname'
	local id = r(id)
	local numnodes = r(nodes)
	qui numlist "`nodes'", sort max(1600)
	local node_list "`r(numlist)'"
	
	local dropnodes ""
	forvalues i = 1/`numnodes' {
		local dropnodes "`dropnodes' `i'"
	}
	foreach j in `node_list' {
		local dropnodes: subinstr local dropnodes "`j'" "", all word
		local dropnodes: subinstr local dropnodes "  " " ", all
		local dropnodes: subinstr local dropnodes `"""' "", all
	}	
	
	nwdropnodes `netname', nodes(`dropnodes')
end




