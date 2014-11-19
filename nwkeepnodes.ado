*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwkeepnodes
program nwkeepnodes 
	version 9
	syntax [anything(name=netname)] [, nodes(string)]
	
	qui nwset
	if "" == "" {
		nwcurrent
		local netname = r(current)
	}
	qui nwname 
	local id = r(id)
	local numnodes = r(nodes)
	qui numlist "", sort max(1600)
	local node_list ""
	
	local dropnodes ""
	forvalues i = 1/ {
		local dropnodes " "
	}
	foreach j in  {
		local dropnodes: subinstr local dropnodes "" "", all word
		local dropnodes: subinstr local dropnodes "  " " ", all
		local dropnodes: subinstr local dropnodes `"""' "", all
	}	
	
	nwdropnodes , nodes()
end




