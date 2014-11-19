*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop _nwsyntax_other
program _nwsyntax_other
	syntax [anything],[min(integer 1) max(integer 1) exactly(integer 0) nocurrent forcedirected(string)]
	
	nwset, nooutput
	local networks = r(networks)
	local user = ""
	
	if "" == ""  & "" == ""{
		nwcurrent
		local anything = r(current)
	}
	// Deal with _all
	if "" == "_all" {
		local allnames = ""
		forvalues i = 1/ {
			nwname, id()
			local newname = r(name)
			local allnames " " 
		}
		local anything ""
	}		
		
	// Deal with *
	di ""
	local newanything ""
	foreach onenet in  {
		local onenet_exp = subinstr("","*",".*",99)
		local newonenet = ""
		forvalues i = 1/2 {
			scalar onename = ""
			local localname = onename
			local sta = regexm("", "^$")
			if  == 1 {
				local newonenet " "
			}
		}
		local newanything : subinstr local newanything "" "", word all
	}
	local anything ""
	
	foreach onenet in  {
		nwname , newdirected()
		local name = r(name)
		local id = r(id)
		local nodes = r(nodes)
		local directed = r(directed)
		
		// remove all self-loops
		mata: _diag(nw_mata, 0)
	}
	
	local anycount : word count 
	if (( > ) | ( < ))&  == 0{
		di "{err}wrong number of networks; only {bf:} allowed"
		error 6020
	}
	if  != 0 {
		local newanything ""
		local last ""
		forvalues i = 1/ {
			local next : word  of 
			if "" != "" {
				local last ""
			}
			else {
				local next ""
			}
			local newanything " "
		}	
		local anything ""
	}
	
	c_local othernetname ""
	c_local othernodes ""
	c_local otherid ""
	c_local othername ""
	c_local otherdirected ""
end

