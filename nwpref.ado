*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwpref
program nwpref
	version 9
	syntax anything(name=nodes) [, ntimes(integer 1) vars(string) stub(string) name(string) m0(integer 2) m(integer 2) prob(real 0) undirected xvars noreplace]
	set more off
	
	if  <= 1 {
		noisily display as error "The number of nodes must be an integer larger than 1."
		error 125
	}

	local directed = ("" == "")

		// Check if this is the first network in this Stata session
	if "2" == "" {
		global nwtotal = 0
	}

	// Generate valid network name and valid varlist
	if "" == "" {
		local name "pref"
	}
	if "" == "" {
		local stub "net"
	}
	nwvalidate 
	local prefname = r(validname)
	local varscount : word count 
	if ( != ){
		nwvalidvars , stub()
		local prefvars " net1_1 net1_2 net1_3 net1_4 net1_5 net1_6 net1_7 net1_8 net1_9 net1_10 net1_11 net1_12"
	}
	else {
		local prefvars ""
	}
	
	if  != 1 {
		di in smcl as txt "{p}"
		forvalues i = 1/{
			if mod(, 25) == 0 {
				di in smcl as txt "..."
			}
			nwpref , m0() m() prob() name(_) stub()  
		}
		exit
	}
	
	mata: newmat = prefattach(,,,,)
	nwset, mat(newmat) vars() name()  
	nwload ,  
	
	
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




