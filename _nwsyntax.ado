*! Date        : 10sept2014
*! Version     : 1.1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop _nwsyntax
program _nwsyntax
	syntax [anything],[max(integer 1) min(passthru) nocurrent name(string) id(string)]
	if "`name'" == "" {
		local name = "netname"
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
		if _rc == 111 {
			di "{err}network `anything' not found"
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

	
	local networks : word count `_temp'
	local lastnet : word `networks' of `_temp'
	mata: st_rclear()
	
	nwname `lastnet'
	local id = r(id)
	mata: _diag(nw_mata`id', 0)
	
	c_local id "`r(id)'"		
	c_local `netname' "`_temp'"
	c_local nodes "`r(nodes)'"
	c_local `name' "`_temp'"
	c_local directed "`r(directed)'"
	c_local networks "`networks'"
	
	
end

