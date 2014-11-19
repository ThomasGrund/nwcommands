*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwhomophily
program def nwhomophily
	syntax varlist(min=1), homophily(string) density(real) [mode(string) nodes(string) name(string) stub(string) xvars undirected]
	
	local vc = wordcount("")
	local hc = wordcount("")
	local mc = wordcount("")
	
	if ( != ) {
		di "{err}option {it:homophily} needs to have as many entries {it:varlist}."
		error 6300
	}

	// Check if this is the first network in this Stata session
	if "2" == "" {
		global nwtotal = 0
	}
	
	if "" == "" {
		local nodes = _N
		foreach var of varlist  {
			qui sum 
			local temp = r(N)
			local nodes = min(,)
		}
	}
	
	// generate valid network name and valid varlist
	if "" == "" {
		local name "assortative"
	}
	if "" == "" {
		local stub "net"
	}
	nwvalidate 
	local assortname= r(validname)
	
	local gencmd "nwgenerate _tempassort ="
	
	forvalues i = 1/{
		local onevar = word("",)
		local onehom = word("",)
		local onemode = word("",)
		local gencmd " exp((_nwexpand , mode()) * ()) *"
	}
	local gencmd " 1"
	qui 
	
	nwdyadprob _tempassort, density() name() 
	nwdrop _tempassort	
end
	
	
	


	
