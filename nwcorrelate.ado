*! Date        : 3sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwcorrelate	
program nwcorrelate
syntax [anything(name=netnames)] [,  mode(string) ATTRibute(string) PERMutations(integer 1) SAVing *]

	// Set mode.
	if "`mode'" == "" {
		local mode = "same"
	}
	
	// Get networks.
    local num = wordcount("`netnames'")
	if (`num' == 0) {
		di "{err}Network not found."
		error 6001
	}
	
	local net1 = word("`netnames'",1)
	
	if "`attribute'" != "" {
		local attr = word("`attribute'", 1)
		confirm variable `attr'
		capture nwdrop `mode'_`attr'
		nwexpand `attr', mode(`mode')
		local net2 = "`mode'_`attr'"
	}
	else {
		if (`num' < 2) {
			di "{err}Wrong number of networks."
			error 6055
		}
		local net2 = word("`netnames'",2)
	}
	
	// Check that networks exists.
	nwname `net1'
	local id1 = r(id)
	local nodes1 = r(nodes)
	nwtomata `net1', mat(corrnet1)

	nwname `net2'
	local id2 = r(id)
	local nodes2 = r(nodes)
	nwtomata `net2', mat(corrnet2)
	
	if (`nodes1' != `nodes2'){
		di "{err}Networks of different size."
		error 6056
	}
	
	local bandwidth `= 1 / `nodes1''
	
	// Return the names and id's of the networks that are correlated with each other.
	mata: st_rclear()
	mata: st_global("r(name_2)", "`net2'")
	mata: st_global("r(name_1)", "`net1'")
	mata: st_numscalar("r(id_1)", `id1')
	mata: st_numscalar("r(id_2)", `id2')
	
	mata: corr = correlate_nets(corrnet1, corrnet2)	
	
	// Simply calculate correlation of two networks.
	if `permutations' == 1 {
		mata: st_numscalar("r(corr)",corr)
		mata: mata drop corrnet1 corrnet2
	}
	// Calculate correlations of network2 with permutations of network1
	else qui {
		mata: corr_reps = correlate_nets_rep(`permutations', corrnet1, corrnet2)
		capture _return drop _all
		tempname myr
		_return hold `myr'
		
		if "`scheme'" == "" {
			local scheme = "s2color"
		}
		
		preserve
		drop _all
		
		mata: st_numscalar("r(corr)", corr)
		nwtostata, mat(corr_reps) gen(correlation)
		gen observed = r(corr)
		if "`saving'"!= "" {
			di "QAP results saved as: `c(pwd)'/nwcorrelationqap.dta" 
			save "`c(pwd)'/nwcorrelationqap.dta", replace
		}
	
		qui count
		local count_total `r(N)'
		mata: st_numscalar("r(corr)", corr)

		if `r(corr)' > 0 {
			qui count if correlation >= `r(corr)'
		}
		else {
			qui count if correlation <= `r(corr)'	
		}
		local count_out `r(N)'
		
		mata: pvalue = `count_out' / `count_total'
		
		_pctile correlation, percentiles(2.5 97.5)
		mata: lb = `r(r1)'
		mata: ub = `r(r2)'
		
		sum correlation
		local xmin = r(min)
		local xmax = r(max)
		mata: st_numscalar("r(corr)", corr)
		
		if `r(corr)' < `xmin' {
			local xmin = `r(corr)'
		}
		if `r(corr)' > `xmax' {
			local xmax = `r(corr)'
		}
		
		kdensity correlation, xscale(range(`xmin' `xmax')) bwidth(`bandwidth') title("Corr(`net1', `net2')") ytitle("density") xline(`r(corr)',lpattern(dash)) xlabel(#5) note(`"based on `permutations' QAP permutations of network `net1'"') `options'	

		restore
		_return restore `myr'
	
		mata: st_numscalar("r(lb)",lb)
		mata: st_numscalar("r(ub)",ub)
		mata: st_numscalar("r(pvalue)", pvalue)
		mata: st_numscalar("r(corr)", corr)
	}
	
	di "{hline 40}"
	di "{txt}  Network name: {res}`r(name_1)'"
	if "`attribute'" != "" {
		di "{txt}  Attribute: {res}`r(name_2)'"
	}
	else {
		di "{txt}  Network2 name: {res}`r(name_2)'"
	}
	di "{hline 40}"
	di "{txt}    Correlation: {res}`r(corr)'"
	_return hold r1
	capture nwdrop `net2'
	_return restore r1
end

capture mata mata drop correlate_nets_rep()
capture mata mata drop correlate_nets()

mata:
real matrix correlate_nets_rep(real scalar reps, real matrix net1, real matrix net2){
	temp_net1 = net1
	nsize = rows(temp_net1)
	results = J(reps, 1, 0)
	for (i = 1; i <= reps; i ++) {
		permutationVec = unorder(nsize)
		perm_net1 = temp_net1[permutationVec, permutationVec]
		results[i] = correlate_nets(perm_net1, net2)
	}
	return(results)
}

real scalar correlate_nets(real matrix net1, real matrix net2){
	net1mean = sum(net1) / ( rows(net1) * rows(net1) - rows(net1))
	net2mean = sum(net2) / ( rows(net2) * rows(net2) - rows(net2))
	mean1 = J(rows(net1), rows(net1), net1mean)
	mean2 = J(rows(net2), rows(net2), net2mean)
	_diag(mean1, J(rows(net1), 1, 0))
	_diag(mean2, J(rows(net2), 1, 0))
	temp1 = net1 :- mean1
	temp2 = net2 :- mean2
	temp1sq = temp1 :* temp1
	temp2sq = temp2 :* temp2
	t1t2 = ((temp1 :* temp2))
	nominator = sum(t1t2)
	denominator = sqrt(sum(temp1sq) * sum(temp2sq))	
	return(nominator/denominator)
}
end
