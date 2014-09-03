*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

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
	if "$nwtotal" == "" {
		global nwtotal = 0
	}
	
	// Get parameters
	nwname `weightnet'	
	local nodes = r(nodes)
	local ties = `nodes' * (`nodes' -1) * `density'
	
	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "dyadprob"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	nwvalidate `name'
	local homoname = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(`stub')
		local homovars "$validvars"
	}
	else {
		local homovars "`vars'"
	}
	
	// Generate network from weight network
	preserve
	nwtoedge `weightnet', full
	
	if "`undirected'" != "" {
		replace `weightnet' = 0 if _toid <= _fromid
	}
	
	gsample `ties' [aweight=`weightnet'], generate(link) wor
	qui nwfromedge _fromid _toid link, name(_tempnetwork)
	nwset net*, name(`homoname') vars(`homovars') `xvars'
	nwdrop _tempnetwork	
	restore
	
	if "`undirected'" != "" {
		nwsym `homoname'
	}
	if "`xvars'" == "" {
		nwload `homoname', `xvars'
	}
end

