// date: 24aug2014
// author: Thomas Grund, Linköping University

capture program drop _nwsyntax
program _nwsyntax
	syntax [anything],[max(integer 1) nocurrent name(string) id(string)]
	if "`name'" == "" {
		local name = "netname"
	}
	if "`id'" == "" {
		local id = "id"
	}
	local netname = "`name'"
	local netid = "`id'"
	
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
	local newanything "`anything'"
	foreach onenet in `anything' {
		local onenet_exp : subinstr local onenet "*" ".*", all
		if (strpos("`one_net'","*") != 0 ) {
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
	}
	local anything "`newanything'"
	
	local nodes_all = 0
	foreach onenet in `anything' {
		nwname `onenet'
		local name = r(name)
		local id = r(id)
		local nodes = r(nodes)
		local nodes_all = `nodes_all' + `nodes'
		local directed = r(directed)
		
		// remove all self-loops
		mata: _diag(nw_mata`id', 0)
	}
	
	local anycount : word count `anything'
	if `anycount' > `max' {
		di "{err}wrong number of networks; only {bf:`max'} allowed"
		error 6020
	}

	c_local id "`id'"		
	c_local `netname' "`anything'"
	c_local nodes "`nodes'"
	c_local nodes_all "`nodes_all'"
	c_local `name' "`name'"
	c_local directed "`directed'"
	c_local networks "`networks'"
end

