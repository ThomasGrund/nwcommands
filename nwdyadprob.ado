*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwdyadprob
program nwdyadprob
	syntax anything(name=weightnet), density(string) [name(string) vars(string) xvars undirected]
	
	// Install gsample if needed
	capture which gsample
	if _rc != 0 {
		ssc install gsample
	}
	capture mata: mata which mm_sample()
	if _rc != 0 {
		ssc install moremata
	}
	
	// Check if this is the first network in this Stata session
	if "2" == "" {
		global nwtotal = 0
	}
	
	// Get parameters
	nwname 	
	local nodes = r(nodes)
	local ties =  * ( -1) * 
	
	// Generate valid network name and valid varlist
	if "" == "" {
		local name "dyadprob"
	}
	if "" == "" {
		local stub "net"
	}
	nwvalidate 
	local homoname = r(validname)
	local varscount : word count 
	if ( != ){
		nwvalidvars , stub()
		local homovars " net1_1 net1_2 net1_3 net1_4 net1_5 net1_6 net1_7 net1_8 net1_9 net1_10 net1_11 net1_12"
	}
	else {
		local homovars ""
	}
	
	// Generate network from weight network
	preserve
	nwtoedge , full
	
	if "" != "" {
		replace  = 0 if _toid <= _fromid
	}
	
	gsample  [aweight=], generate(link) wor
	qui nwfromedge _fromid _toid link, name(_tempnetwork)
	nwset net*, name() vars() 
	nwdrop _tempnetwork	
	restore
	
	if "" != "" {
		nwsym 
	}
	if "" == "" {
		nwload , 
	}
end

