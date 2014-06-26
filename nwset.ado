*! Date        : 9 Nov 2013
*! Version     : 1.0
*! Author      : Thomas Grund
*! Email       : thomas.grund@iffs.se
*! Description : Set the network

capture program drop nwset	
program nwset
syntax [varlist (default=none)][, nooutput name(string) vars(string) labs(string asis) edgelabs(string asis) detail mat(string) undirected directed]
	set more off
	
	local numnets = 0
	mata: st_rclear()
	local max_nodes = 0
	
	// display information about network
	if ("`varlist'" == "" & "`mat'" == "") {
		if ("$nwtotal" == "" | "$nwtotal" == "0") {
			mata: st_numscalar("r(networks)", 0)
			noi di "{err}No network found."
			error 6001
		}
		else { 
			if ("`output'" != "nooutput") {
				local networks = plural($nwtotal, "network")
				di "{txt}($nwtotal `networks')"
				// information about networks
				forvalues i=1/`=$nwtotal'{		
					scalar onesize = "\$nwsize_`i'"
					local thissize `=onesize'
					local max_nodes = max(`max_nodes', `thissize')
					scalar onename = "\$nwname_`i'"
					scalar onenw = "\$nw_`i'"
					scalar onelabs = "\$nwlabs_`i'"
					local l `"`=onelabs'"'
					scalar onedirected = "\$nwdirected_`i'"
					scalar oneedgelabs = "\$nwedgelabs_`i'"
					di 
					di "{hline 50}"
					if (`i' == $nwtotal){
						di "{txt} `i') Current Network"
					}
					else {
						di "{txt} `i') Stored Network"
					}
					di "{hline 50}"
					di "{txt}   Network name: {res}`=onename'"
					di "{txt}   Directed: {res}`=onedirected'"
					di "{txt}   Nodes: {res}`=onesize'"
								
					if ("`detail'" != ""){
						di "{txt}   Network id: {res}`i'"
						di "{txt}   Variables: {res}`=onenw'"
						di `"{txt}   Labels: {res}`=onelabs'"'
						di `"{txt}   Edgelabels: {res}`=oneedgelabs'"'
					}
				}
			}
		}
	}
	// set the network
	else {
		// set network from varlist
		if "`varlist'" != "" {
			local size :word count `varlist'
			local varscount : word count `vars'
			local labscount : word count `labs'
			qui nwtomata `varlist', copy mat(onenet)
			local mat = "onenet"
			if (`varscount' != `size') unab vars: `varlist'
			if (`labscount' != `size') local labs "`vars'"

		}
		// set network from mata matrix
		else {
			// either varlist or mat needs to be given
			if ("`mat'" == ""){
				di "{err}either {it:varlist} or option {it:mat()} needs to be specfied"
				exit
			}
			// mat is given
			else {
				mata: onenet = `mat' 
				mata: st_numscalar("msize", rows(`mat'))
				local size = msize
				local varscount : word count `vars'
				local labscount : word count `labs'
				// generate vars"
				if("`varscount'" != "`size'"){
					local vars ""
					forvalues i = 1/`size' {
						local vars "`vars' var`i'"
					}
				}
				// get labels
				if (`labscount' != `size'){
					local labs "`vars'"
				}
			}
		}

		if "`name'" == "" {
			local name "network"
		}
		
		nwvalidate `name'
		local name = r(validname)
			
		if "$nwtotal" == "" {
			global nwtotal 0
		}
		
		local directed_new = "true"
		if "`undirected'" != "" {
			local directed_new = "false"
		}
		if"`directed'" != "" {
			local directed_new = "true"
		}

		local new_nwtotal = $nwtotal + 1
		mata: nw_mata`new_nwtotal' = onenet
		global nw_`new_nwtotal' "`vars'"
		
		global nwlabs_`new_nwtotal' `"`labs'"'
		global nwedgelabs_`new_nwtotal' `"`edgelabs'"'
		global nwsize_`new_nwtotal' "`size'"
		global nwname_`new_nwtotal' "`name'"
		global nwdirected_`new_nwtotal' "`directed_new'"
		
		global nwtotal = `new_nwtotal'
		global nwtotal_mata = $nwtotal

		mata: mata drop onenet
	}
	
	mata: st_rclear()
	mata: st_numscalar("r(networks)", $nwtotal)
	mata: st_numscalar("r(max_nodes)", `max_nodes')

end
