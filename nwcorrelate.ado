*! Date        : 3sept2014
*! Version     : 1.0.4
*! Author      : Thomas Grund, Linkoping University
*! Email	   : contact@nwcommands.org

capture program drop nwcorrelate
program nwcorrelate

	gettoken anything opts: 0, parse(",") 
	local ifstart = strpos("`anything'", "if")
	local netname = cond(`ifstart'!= 0, substr("`anything'",1,`=`ifstart'-1'), "`anything'")
	local ifcond =  cond(`ifstart'!= 0, substr("`anything'",`=`ifstart' + 3',.), "")
	local ifcond = "ifcond(`ifcond')"
	
	local 0 "`netname' `opts'"
	syntax [anything(name=netname)] [, ATTribute(string) * ]
	_nwsyntax `netname', min(1) max(2)
	if "`attribute'"!= "" {
		nwcorrelate_nets `netname', `ifcond' attribute(`attribute') `options'
	}
	if `networks' == 2 {
		nwcorrelate_nets `netname', `ifcond' `options'
	}
	if `networks' == 1 & "`attribute'" == ""{
		nwcorrelate_nodes `netname', `ifcond' `options'
	}
end

capture program drop nwcorrelate_nodes
program nwcorrelate_nodes
	syntax [anything(name=netname)] [, ifcond(string) name(string) context(string)]
	_nwsyntax `netname'
	
	// Deal with if condition

	if "`name'" == "" {
		local name = "_corr"
	}
	
	capture nwdrop `name'
	
	local neighborhood = 1
	if "`context'" == "incoming" {
		local neighborhood = 2
	}
	if "`context'" == "both" {
		local neighborhood = 3
	}
	nwtomatafast `netname'
	mata: corr = correlate_nodes(`r(mata)', `neighborhood')
	if "`ifcond'" != "" {
		_nwevalnetexp `ifcond' % _ifnet, nodes(`nodes')	
		mata: corr = corr :*  _ifnet + (J(`nodes',`nodes', 1) :- _ifnet):* (-9999)
		mata: _editvalue(corr, -9999,.)
		mata: mata drop _ifnet
	}	
	nwset, mat(corr) name("`name'")	
	
	mata: _diag(corr, .)
	mata: st_rclear()
	mata: st_numscalar("r(avg_corr)", ( sum(corr) / sum(corr:!=.)))
	mata: mata drop corr
	
	mata: st_global("r(name)", "`netname'")
	mata: st_global("r(corrname)", "`name'")
	mata: st_global("r(context)", "`context'")
	di 
	di "{txt}  Network name: {res}`r(name)'"
	di "{txt}  Correlation name: {res}`r(corrname)'"
	di "{hline 40}"
	di "{txt}    Context definition: {res}`r(context)'"
	di "{txt}    Average Correlation Between Nodes: {res}`r(avg_corr)'"
end


capture program drop nwcorrelate_nets	
program nwcorrelate_nets
syntax [anything(name=netnames)]  [,  ifcond(string) context(string) mode(string) ATTRibute(string) PERMutations(integer 1) SAVe(string asis) *]
	_nwsyntax `netnames', max(2) min(1)
	local netnames `netname'
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
	
	if "`ifcond'" != "" {
		_nwevalnetexp `ifcond' % ifcond, nodes(`nodes')	
	}
	else {
		mata: ifcond = J(`nodes',`nodes', 1)
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
	
	mata: corr = correlate_nets(corrnet1, corrnet2, ifcond)	
	
	// Simply calculate correlation of two networks.
	if `permutations' == 1 {
		mata: st_numscalar("r(corr)",corr)
		mata: mata drop corrnet1 corrnet2
	}
	// Calculate correlations of network2 with permutations of network1
	else qui {
		mata: corr_reps = correlate_nets_rep(`permutations', corrnet1, corrnet2, ifcond)
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
		if "`save'"!= "" {
			di "QAP results saved as: `c(pwd)'/nwcorrelationqap.dta" 
			save "`save'", replace
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
	if "`r(pvalue)'" != "" {
		di "{txt}    P-value: {res}`r(pvalue)'"
	}
	_return hold r1
	if "`attribute'" != "" {
		capture nwdrop `net2'
	}
	_return restore r1
	capture mata: mata drop ifcond
end

capture mata mata drop correlate_nets_rep()
capture mata mata drop correlate_nets()
capture mata: mata drop correlate_nodes()
mata:

real matrix correlate_nodes(real matrix net, scalar outinboth){

	C = J(rows(net), cols(net), 0)
	for(i = 1; i<= rows(net); i++){
		for(j = 1; j<= cols(net); j++){
				
			selection = J(1, cols(net), 1)
			selection[i] = 0
			selection[j] = 0
			i_outvec = (select(net[i,.], selection))'
			i_invec = (select(net[.,i]', selection))'	
			j_outvec = (select(net[j,.], selection))'
			j_invec = (select(net[.,j]', selection))'
			
			if (outinboth == 1) {
				temp = J(rows(i_outvec), 2, 0)
				temp[.,1] = i_outvec
				temp[.,2] = j_outvec
				Corr = correlation(temp)
		
				if (Corr[2,1]==.){
					ctemp = (sum(i_outvec), sum(j_outvec))
					cmax = max(ctemp)
					cmin = min(ctemp)
					if (cmin > 0) {
						Corr[2,1] = cmin / cmax
					}
					if (cmin == 0 & cmax > 0) {
						Corr[2,1] = -1
					}
					if (cmin == 0 & cmax == 0) {
						Corr[2,1] = 1
					}
				}
				C[i,j] = Corr[2,1]
			}
			if (outinboth == 2) {
				temp = J(rows(i_invec), 2, 0)
				temp[.,1] = i_intvec
				temp[.,2] = j_invec
				Corr = correlation(temp)
				
				if (Corr[2,1]==.){
					ctemp = (sum(i_outvec), sum(j_outvec))
					cmax = max(ctemp)
					cmin = min(ctemp)
					if (cmin > 0) {
						Corr[2,1] = cmin / cmax
					}
					if (cmin == 0 & cmax > 0) {
						Corr[2,1] = -1
					}
					if (cmin == 0 & cmax == 0) {
						Corr[2,1] = 1
					}
				}
				C[i,j] = Corr[2,1]
			}
			if (outinboth == 3) {
				num_cols = cols(i_outvec)
				num_rows = rows(i_invec)
				num =  nim_cols + num_rows
				temp = J(num,2,0)
				temp[(1::num_cols),1] = i_outvec
				temp[((num_cols + 1)::num),1] = i_invec
				temp[(1::num_cols),2] = j_outvec
				temp[((num_cols + 1)::num),2] = j_invec			

				Corr = correlation(temp)
				
				if (Corr[2,1]==.){
					ctemp = (sum(i_outvec), sum(j_outvec))
					cmax = max(ctemp)
					cmin = min(ctemp)
					if (cmin > 0) {
						Corr[2,1] = cmin / cmax
					}
					if (cmin == 0 & cmax > 0) {
						Corr[2,1] = -1
					}
					if (cmin == 0 & cmax == 0) {
						Corr[2,1] = 1
					}
				}
				C[i,j] = Corr[2,1]
			}
		}
	}
	return(C)
}


real matrix correlate_nets_rep(real scalar reps, real matrix net1, real matrix net2, real matrix ifcond){
	temp_net1 = net1
	nsize = rows(temp_net1)
	results = J(reps, 1, 0)
	for (i = 1; i <= reps; i ++) {
		permutationVec = unorder(nsize)
		perm_net1 = temp_net1[permutationVec, permutationVec]
		results[i] = correlate_nets(perm_net1, net2, ifcond)
	}
	return(results)
}

real scalar correlate_nets(real matrix net1, real matrix net2, real matrix ifcond){
	r = rows(net1)
	c = cols(net1)
	Z = J(r,c,1) - I(r,c)
	temp = J((r * (c - 1)),2, 0)
	temp[.,1] = select(vec(net1), vec(Z))
	temp[.,2] = select(vec(net2), vec(Z))
	
	tempif = select(vec(ifcond), vec(Z))
	temp = select(temp, tempif)
	
	corr = correlation(temp)
	return(corr[2,1])
}
end
