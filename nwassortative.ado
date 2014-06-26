capture program drop nwassortative
program def nwassortative
	syntax varlist(min=1), homophily(string) density(real) [mode(string) vars(string) nodes(string) name(string) stub(string) xvars undirected]
	
	local vc = wordcount("`varlist'")
	local hc = wordcount("`homophily'")
	local mc = wordcount("`mode'")
	
	if (`vc' != `hc') {
		di "{err}option {it:homophily} needs to have as many entries {it:varlist}."
		error 6300
	}

	// Check if this is the first network in this Stata session
	if "$nwtotal" == "" {
		global nwtotal = 0
	}
	
	if "`nodes'" == "" {
		local nodes = _N
		foreach var of varlist `varlist' {
			qui sum `varlist'
			local temp = r(N)
			local nodes = min(`temp',`nodes')
		}
	}
	
	// generate valid network name and valid varlist
	if "`name'" == "" {
		local name "assortative"
	}
	if "`stub'" == "" {
		local stub "net"
	}
	nwvalidate `name'
	local assortname = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(net)
		local assortvars "$validvars"
	}
	else {
		local assortvars "`vars'"
	}
	
	local gencmd "nwgenerate _tempassort ="
	
	forvalues i = 1/`vc'{
		local onevar = word("`varlist'",`i')
		local onehom = word("`homophily'",`i')
		local onemode = word("`mode'",`i')
		local gencmd "`gencmd' exp((_nwexpand `onevar', mode(`onemode')) * `onehom') *"
	}
	local gencmd "`gencmd' 1"
	`gencmd'
	
	nwdyadprob _tempassort, density(`density') vars(`assortvars') name(`assortname') `undirected'
	nwdrop _tempassort	
end
	
	
	


	
