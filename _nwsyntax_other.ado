capture program drop _nwsyntax_other
program _nwsyntax_other
	syntax [anything],[min(integer 1) max(integer 1) exactly(integer 0) nocurrent forcedirected(string)]
	
	nwset, nooutput
	local networks = r(networks)
	local user = "`anything'"
	
	if "`anything'" == ""  & "`current'" == ""{
		nwcurrent
		local anything = r(current)
	}
	// Deal with _all
	if "`anything'" == "_all" {
		local allnames = ""
		forvalues i = 1/`networks' {
			nwname, id(`i')
			local newname = r(name)
			local allnames "`allnames' `newname'" 
		}
		local anything "`allnames'"
	}		
		
	// Deal with *
	di "`newanything'"
	local newanything "`anything'"
	foreach onenet in `anything' {
		local onenet_exp = subinstr("`onenet'","*",".*",99)
		local newonenet = ""
		forvalues i = 1/$nwtotal {
			scalar onename = "\$nwname_`i'"
			local localname = onename
			local sta = regexm("`localname'", "^`onenet_exp'$")
			if `sta' == 1 {
				local newonenet "`newonenet' `localname'"
			}
		}
		local newanything : subinstr local newanything "`onenet'" "`newonenet'", word all
	}
	local anything "`newanything'"
	
	foreach onenet in `anything' {
		nwname `onenet', newdirected(`forcedirected')
		local name = r(name)
		local id = r(id)
		local nodes = r(nodes)
		local directed = r(directed)
		
		// remove all self-loops
		mata: _diag(nw_mata`id', 0)
	}
	
	local anycount : word count `anything'
	if ((`anycount' > `max') | (`anycount' < `min'))& `exactly' == 0{
		di "{err}wrong number of networks; only {bf:`max'} allowed"
		error 6020
	}
	if `exactly' != 0 {
		local newanything ""
		local last ""
		forvalues i = 1/`exactly' {
			local next : word `i' of `anything'
			if "`next'" != "" {
				local last "`next'"
			}
			else {
				local next "`last'"
			}
			local newanything "`newanything' `next'"
		}	
		local anything "`newanything'"
	}
	
	c_local othernetname "`anything'"
	c_local othernodes "`nodes'"
	c_local otherid "`id'"
	c_local othername "`name'"
	c_local otherdirected "`directed'"
end

