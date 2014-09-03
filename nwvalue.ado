*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwvalue	
program nwvalue
	local netname ="`0'"
	
	// a specific entries are given
	local ego = strpos("`netname'","[") 
	local alter = strpos("`netname'","]") 
	local sep = strpos("`netname'",",")
	local subset = substr("`netname'",`ego',.)
	if (`ego' != 0) {
		local e1 = `ego' + 1
		local e2 = `sep' - `ego' - 1
		local a1 =  `sep' + 1
		local a2 = `alter' - `sep' - 1
		local n1 = `ego' - 1
		local egoid = substr("`netname'", `e1', `e2')
		local alterid = substr("`netname'", `a1', `a2')
		local netname = substr("`netname'", 1, `n1')
	}
	nwtomata `netname', mat(onenet)
	capture mata: onenet`subset'
	if _rc != 0 {
		di "{err}{it:nwsubset} {bf:`subset'} invalid"
		error 6400
	}
	
	mata: st_rclear()
	if (`ego'!= 0) {
		mata: subnet = onenet[`egoid',`alterid']
		mata: st_numscalar("r(rows)", rows(subnet))
		mata: st_numscalar("r(cols)", cols(subnet))

		if (`r(rows)' == 1 & `r(cols)' == 1) {
			mata: st_rclear()
			mata: st_numscalar("r(value)", subnet[1,1])
			mata: mata drop subnet
			di r(value)
		}
		else {
			mata: st_global("r(mata)", "subnet")
		}	
	}
	else {
		mata: subnet = onenet
		mata: st_numscalar("r(rows)", rows(subnet))
		mata: st_numscalar("r(cols)", cols(subnet))
		mata: st_global("r(mata)", "subnet")
	}
end
