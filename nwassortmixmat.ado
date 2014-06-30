capture program drop nwassortmixmat
program nwassortmixmat
	syntax anything(name=weightnet), density(string) [undirected]
	
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
		local name "homophily"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	nwvalidate `name'
	nwvalidvars `nodes', stub(`stub')
	local homoname = r(validname)
	local homovars "$validvars"
	
	// Generate network from weight network
	preserve
	
	nwtoedge `weightnet', full
	gsample `ties' [aweight=`weightnet'], generate(link) wor

	nwfromedge fromid toid link, name(_tempnetwork)
	nwset net*, name(`homoname') vars(`homovars') `xvars'
	nwdrop _tempnetwork	
	restore
	nwload `homoname', `xvars'
	
end

