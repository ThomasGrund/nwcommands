*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwvalue	
program nwvalue
	local netname ="nwvalue.ado, date(18nov2014) author(Thomas Grund) email(thomas.u.grund@gmail.com) version(1.0.4.1) other()"
	
	gettoken netname exp : netname, parse("=")
	
	// a specific entries are given
	local ego = strpos("","[") 
	local alter = strpos("","]") 
	local sep = strpos("",",")
	local subset = substr("",,.)
	if ( != 0) {
		local e1 =  + 1
		local e2 =  -  - 1
		local a1 =   + 1
		local a2 =  -  - 1
		local n1 =  - 1
		local egoid = substr("", , )
		local alterid = substr("", , )
		local netname = substr("", 1, )
	}

	nwtomata , mat(onenet)
	capture mata: onenet
	if _rc != 0 {
		di "{err}{it:nwsubset} {bf:} invalid"
		error 6400
	}
	
	mata: st_rclear()
	if (!= 0) {
		/*
		if "" != "" {
			local exp : subinstr local exp "=" ""
			mata: onenet[,] = J(rows(onenet[,]), cols(onenet[,]), )
		}
		*/
		mata: subnet = onenet[,]
		mata: st_numscalar("r(rows)", rows(subnet))
		mata: st_numscalar("r(cols)", cols(subnet))

		if ( == 1 &  == 1) {
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
