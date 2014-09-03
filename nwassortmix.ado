*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwassortmix
program def nwassortmix
	syntax varlist(min=1), homophily(string) density(real) [mode(string) nodes(string) name(string) stub(string) xvars undirected]
	
	local vc = wordcount("`varlist'")
	local hc = wordcount("`homophily'")
	local mc = wordcount("`'")
	
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
	local assortnam= r(validname)
	
	local gencmd "nwgenerate _tempassort ="
	
	forvalues i = 1/`vc'{
		local onevar = word("`varlist'",`i')
		local onehom = word("`homophily'",`i')
		local onemode = word("`mode'",`i')
		local gencmd "`gencmd' exp((_nwexpand `onevar', mode(`onemode')) * (`onehom')) *"
	}
	local gencmd "`gencmd' 1"
	qui `gencmd'
	
	nwdyadprob _tempassort, density(`density') name(`assortname') `undirected'
	nwdrop _tempassort	
end
	
	
	


	
