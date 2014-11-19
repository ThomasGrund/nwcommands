*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwreach
program nwreach
	syntax [anything(name=reachnet)], [ name(string) vars(string) xvars symoff noreplace]
	_nwsyntax , name(reachnet)

	// Generate valid name and vars
	if "" == "" {
		local name "reach"
	}
	if "" == "" {
		local stub "_reach"
	}

	if "" != "noreplace" {
		capture nwdrop reach
	}

	nwvalidate 
	local reachname = r(validname)
	local varscount : word count 
	if ( != ){
		nwvalidvars , stub()
		local reachvars " net1_1 net1_2 net1_3 net1_4 net1_5 net1_6 net1_7 net1_8 net1_9 net1_10 net1_11 net1_12"
	}
	else {
		local reachvars ""
	}	
	
	nwgeodesic , name() vars() unconnected(0)  
	nwreplace  = 1 if  >= 0
	nwname , newdirected(true)
end
