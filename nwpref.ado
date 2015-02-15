*! Date        : 11nov2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwpref
program nwpref
	version 9
	syntax anything(name=nodes) [, labs(string) ntimes(integer 1) vars(string) stub(string) name(string) m0(integer 2) m(integer 2) prob(real 0) undirected xvars noreplace]
	set more off
	
	if `nodes' <= 1 {
		noisily display as error "The number of nodes must be an integer larger than 1."
		error 125
	}

	local directed = ("`undirected'" == "")

		// Check if this is the first network in this Stata session
	if "$nwtotal" == "" {
		global nwtotal = 0
	}

	// Generate valid network name and valid varlist
	if "`name'" == "" {
		local name "pref"
	}
	if "`stub'" == "" {
		local stub "pref"
	}
	nwvalidate `name'
	local prefname = r(validname)
	local varscount : word count `vars'
	if (`varscount' != `nodes'){
		nwvalidvars `nodes', stub(`stub')
		local prefvars "$validvars"
	}
	else {
		local prefvars "`vars'"
	}
	
	if `ntimes' != 1 {
		di in smcl as txt "{p}"
		forvalues i = 1/`ntimes'{
			if mod(`i', 25) == 0 {
				di in smcl as txt "...`i'"
			}
			nwpref `nodes', m0(`m0') m(`m') prob(`prob') name(`name'_`i') stub(`stub') `xvars' `undirected' vars(`vars') labs(`labs')
		}
		exit
	}
	
	mata: newmat = prefattach(`nodes',`m0',`m',`prob',`directed')
	nwset, mat(newmat) vars(`prefvars') name(`prefname') `undirected' labs(`labs')
	nwload `prefname', `xvars' 
	
	
end

capture mata: mata drop prefattach()

mata:
real matrix prefattach(real scalar nodes, real scalar m0, real scalar m, real scalar prob, real scalar directed)
{
	
	// initiate G_0
	net = J(nodes, nodes, 0)
	for (i = 1; i <= m0; i++){
		for (j= 1;j<= m0;j++){
			net[i,j] = 1
			net[j,i] = 1
		}
	}
	
	// for all new nodes
	for (i= (m0+1); i<=nodes; i++) {  
		newpicks = 0
		if (runiform(1,1) <= prob){
			probability = J((i-1), 1, (1 / (i-1)))	
		}
		else { 
			probability = colsum(net) :/ sum(colsum(net))
		}
		z = min((m\m0))
		if (probability == 1) {
			probability = (1\0)
		}
		while (newpicks < z){
			pick = rdiscrete(1,1, probability)
			if (net[i, pick] == 0 ){
				newpicks = newpicks + 1
				net[i, pick] = 1
				if (directed == 0){
					net[pick,i] = 1
				}
			}
		}
		
	}
	
	return(net)
}

end




