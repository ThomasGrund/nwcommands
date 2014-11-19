*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop _nwsyntax
program _nwsyntax
	syntax [anything],[max(integer 1) min(passthru) nocurrent name(string) id(string)]
	if "" == "" {
		local name = "netname"
	}
	if "" == "" {
		local id = "id"
	}
	local netname = ""
	local netid = ""
	
	if "" == ""  & "" == ""{
		nwcurrent
		local anything = r(current)
	}
	
	capture nwunab _temp : , max() 
	if _rc != 0 {
		if _rc == 111 {
			di "{err}network  not found"
			error 6001
		}
		if _rc == 102 {
			di "{err}"
			di "too few networks specified"
			error 6002
		}
		if _rc == 103 {
			di "{err}"
			di "too many networks specified"
			error 6003
		}
	}

	
	local networks : word count 
	local lastnet : word  of 
	mata: st_rclear()
	
	nwname 
	local id = r(id)
	mata: _diag(nw_mata, 0)
	
	c_local id ""		
	c_local  ""
	c_local nodes ""
	c_local  ""
	c_local directed ""
	c_local networks ""
	
	
end

