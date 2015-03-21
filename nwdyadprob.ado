*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwdyadprob
program nwdyadprob
	syntax [anything(name=weightnet)],  [ density(real 0) mat(string) name(string) vars(string) xvars undirected]
		
	// Install gsample if needed
	capture which gsample
	if _rc != 0 {
		ssc install gsample
	}
	capture mata: mata which mm_sample()
	if _rc != 0 {
		ssc install moremata
	}

	
	if "`weightnet'" != "" {
		_nwsyntax `weightnet'
	}

	
	// Generate network from weight network
	preserve
	qui if "`mat'" != "" {
		capture mat list `mat'
		if _rc == 0 {
			noi mata: `mat' = st_matrix("`mat'")
		}
	
		capture mata: `mat'
		if _rc == 0 {
			mata: st_numscalar("r(validmata)", (rows(`mat') == cols(`mat')))
			if `r(validmata)' == 1 {
				mata: st_numscalar("r(nodes)", rows(`mat'))
				local nodes = `r(nodes)'
				local ties = `nodes' * (`nodes' -1) * `density'
				tempname dyads
				mata: `dyads' = colshape(`mat', 1)
				drop _all
				getmata `dyads'
				rename `dyads' `mat'
				local weightnet "`mat'"
				gen _fromid = mod(_n,`nodes')
				gen _toid = ceil(_n /`nodes')
				replace _fromid = 1 if _fromid == 0
			}
		}
	}
	else {
		qui nwtoedge `weightnet', full forcedirected
	}
	
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
	
	qui if "`undirected'" != "" {
		replace `weightnet' = 0 if _toid <= _fromid
	}
	
	qui if "`density'" != "" {
		local ties = `nodes' * (`nodes' -1) * `density'
		qui gen _nonzero = (`weightnet' > 0)
		qui sum _nonzero
		if `r(sum)' < `ties' {
			di "{err}Not enough non-zero weights to generate `ties' ties"
			exit
		}
		qui drop if _fromid == _toid
		gsample `ties' [aweight=`weightnet'], generate(link) wor
	}
	else {
		gen link = (`weightnet' > uniform())
	}
	
	
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

