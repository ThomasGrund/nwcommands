*! Date        : 10sept2014
*! Version     : 1.1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop _nwsyntax
program _nwsyntax
	syntax [anything],[max(integer 1) min(passthru) nocurrent name(string) id(string)]
		
	if ("$nwtotal" == "" | "$nwtotal" == "0") {
		noi di "{err}No network found."
		error 6001
	}
	
	if "`name'" == "" {
		local name = "netname"
	}
	if "`nodes'" == "" {
		local nodes = "nodes"
	}
	if "`networks'" == "" {
		local networks = "networks"
	}
	if "`directed'" == "" {
		local directed = "directed"
	}
	if "`id'" == "" {
		local id = "id"
	}
	local netname = "`name'"
	local netid = "`id'"
	
	if "`anything'" == ""  & "`current'" == ""{
		nwcurrent
		local anything = r(current)
	}
	
	capture nwunab _temp : `anything', max(`max') `min'
	if _rc != 0 {
		if _rc == 111 | _rc == 198 {
			di "{err}network {bf:`anything'} not found"
			error 6001
		}
		if _rc == 102 {
			di "{err}`anything'"
			di "too few networks specified"
			error 6002
		}
		if _rc == 103 {
			di "{err}`anything'"
			di "too many networks specified"
			error 6003
		}
	}

	local networkscnt : word count `_temp'
	local lastnet : word `networkscnt' of `_temp'
	mata: st_rclear()
	
	nwname `lastnet'
	local netid = r(id)
	//mata: _diag(nw_mata`netid', 0)
	
	c_local `id' "`r(id)'"		
	c_local `netname' "`_temp'"
	c_local `nodes' "`r(nodes)'"
	c_local `name' "`_temp'"
	c_local `directed' "`r(directed)'"
	c_local `networks' "`networkscnt'"
	mata: st_rclear()
	
	
end

