capture program drop nwqap	
program nwqap
syntax [anything (name=formula)] [, detail type(string) typeoptions(string) mode(string) PERMutations(integer 500) save(string) ]
    set more off

	mata: st_rclear()
	
	if "`type'" == "" {
		local type = "logit"
	}
	
	// Get general information.
	local vars = wordcount("`formula'")
	if (`vars' < 1) {
		di "{err}Formula wrongly specified."
		error 6057
	}
	
	local net = word("`formula'", 1)
	_nwsyntax `net', max(1)	
	nwtomata `net', mat(dvnet)
	
	// Generate dataset in long format.
	mata: datalong = J((`nodes' * `nodes'),`vars', 0)
	
	local i = 1
	local t = 1
	
	local prefix ""
	
	foreach entry in `formula' {
		nwvalidate `entry'
		// DV or IV is network
		if (r(exists) == "true") {
			nwname `entry'
			local nextname "`r(name)'"
			if r(nodes) != `nodes' {
				di "{err}Networks of different size."
				error 6056
			}
			nwtomata `entry', mat(onenet)
			mata: _diag(onenet, J(rows(onenet), 1, .))
			mata: temp = transformIntoLong(onenet)
			mata: datalong[,`i'] = temp
			local i = `i' + 1
			local prefix "`prefix' `nextname'"
		}
		// Assume IV to be a variable.
		else {
			confirm variable `entry'
			// Make network out of IV.
			tokenize `mode'
			nwexpand `entry', name(_tempexpand) mode("``t''") nodes(`nodes')
			nwtomata _tempexpand, mat(onenet)
			mata: _diag(onenet, J(rows(onenet), 1, .))
			mata: temp = transformIntoLong(onenet)
			mata: datalong[,`i'] = temp
			local i = `i' + 1
			nwdrop _tempexpand
			if "``t''" == "" {
				local prefix "`prefix' same_`entry'"
			}
			else {
				local prefix "`prefix' ``t''_`entry'"
			}
			local t = `t' + 1
		}
	}
		
	preserve
	drop _all
	local obs = `nodes' * `nodes'
	qui set obs `obs'
	qui foreach entry in `formula' {
		gen `entry' = .
	}
	mata: st_store(.,.,datalong)
		
	tempname memhold
    tempfile results
	
	qui gen `net'_original = `net'
	qui replace `net' = .
	
	quietly postfile `memhold' `formula' using `results', replace
	
	// Run regression on permutations.
	set more off
	di 
	local perm_running 1
	qui forvalues j = 1/`permutations' {
		if `j' == 1 {
			noisily di "{txt}Permutation: 1 out of `permutations'"
		}
		if `j' / 50 >= `perm_running' {
			noisily di "{txt}Permutation: `=`perm_running'*50' out of `permutations'"
			local perm_running = `perm_running' + 1
		}
		mata: perm_net = permute_net(dvnet)
		mata: net_long = transformIntoLong(perm_net)
		mata: st_store(., "`net'", net_long)
		`type' `formula', `typeoptions'
	
		mat temp_coeff = e(b)
		local post_txt = ""
		local varsminus = `vars' - 1
		forvalues i = 1/`varsminus' {
			local post_txt = "`post_txt' (`=round(temp_coeff[1,`i'], 0.0001)')"
		}
		local post_txt ="(`=round(_b[_cons], 0.0001)') `post_txt'"
		post `memhold' `post_txt'
	}
	postclose `memhold'
	
	// Run regression with original data.
	qui replace `net' = `net'_original
	if "`detail'" != "" {
		`type' `formula'
	}
	else {
		quietly `type' `formula'
	}
	mat reg_results = e(b)
	
	// Calculate p-values.
	use `results', clear
	if "`save'" != "" {
		save "`save'", replace
	}	
	matrix pvalues = J(1, `vars', .)
	local k = 1
	qui foreach entry in `formula' {
		if ("`entry'" == "`net'") {
			local orig_result = reg_results[1,`vars']
		}
		else {
			local orig_result = reg_results[1,`k']
		}
		
		local novariation = "false"	
		sum `entry'
		if (`r(sd)' == 0) {
			local novariation = "true"
			di "`novariation'"
		}
		local diff = abs(r(mean) - `orig_result')
		local upper_mark = r(mean) + `diff'
		local lower_mark = r(mean) - `diff'
		count if `entry' > `upper_mark'
		local upper = r(N)
		count if `entry' < `lower_mark'
		local lower = r(N)	
		local outer = `upper' + `lower'	
		count
		local total = r(N)
		local p = `outer' / `total'	
		if "`novariation'" == "true" {
			local p = "."
		}
		if ("`entry'" == "`net'") {
			mat pvalues[1,`vars'] = `p'
		}
		else {
			mat pvalues[1,`k'] = `p'
			local k = `k' + 1
		}
	}	
	restore
	
	//  Display results.
	local max_l = 0
	tokenize "`prefix'"
	if `max_l' < 20 {
		local max_l = 20
	}
	di 
	di 
	qui nwsummarize `net'
	local dyads = `r(nodes)' * `r(nodes)' - `r(nodes)' 
	di "{txt}Multiple Regression Quadratic Assignment Procedure"
	di
	di "{txt}  Estimation{col 25}={res}  QAP" 
	di "{txt}  Regression{col 25}={res}  `type'"
	di "{txt}  Permutations{col 25}={res}  `permutations'"  
	di "{txt}  Number of vertices{col 25}=  {res}`r(nodes)'" 
	if r(directed) == "true" {
		di "{txt}  Number of arcs{col 25}=  {res}`r(arcs)'" 
	}
	if r(directed) == "false" {
		di "{txt}  Number of edges{col 25}=  {res}`r(edges)'"
	}
	//di "{txt}  Number of dyads{col 25}=  {res}`dyads'"
	di 
	di "{txt}{hline `=`max_l' + 3'}{c TT}{hline 25}"
	di "{col 2}{ralign `=`max_l'+1':`net'}{col `=`max_l' + 4'}{c |}{col `=`max_l' + 11'}Coef.{col `=`max_l' + 20'}P-value"
	di "{hline `=`max_l' + 3'}{c +}{hline 25}"
	local constant = round(reg_results[1,`=`vars''], 0.000001)
	
	forvalues k=2/`vars'{
		local coeff = `=round(float(reg_results[1,`=`k'-1']), 0.000001)'
		local pvalue = `=round(float(pvalues[1,`=`k'-1']),0.001)'
		di as text "{txt}{col 2}{ralign `=`max_l'+1':``k''}{col `=`max_l' + 4'}{c |}{col `=`max_l' + 5'}{ralign 11:{res}`coeff'}{col `=`max_l' + 20'}{ralign 5:`pvalue'}"
	}
	di "{txt}{col 2}{ralign `=`max_l'+1':_cons}{col `=`max_l' + 4'}{c |}{col `=`max_l' + 5'}{ralign 11:{res}`constant'}"
	di "{txt}{hline `=`max_l' + 3'}{c BT}{hline 25}"
	di "{error}`message'"
	
	mata: st_global("e(title)", "Multivariate regression quadratic assignment procedure")
	mata: p = st_matrix("pvalues")
	mata: st_matrix("e(pvalues)", p)
	mata: mata drop datalong net_long perm_net onenet dvnet p

end

capture mata mata drop transformIntoLong()
capture mata mata drop permute_net()
mata:	
real matrix transformIntoLong(real matrix mymat){ 
	size = rows(mymat)
	mymatlong = J((size * size), 1, 0)
	for (j = 1 ; j <= size; j++) {
		startindex = ((j-1) * size) + 1
		endindex = (j*size) 
		mymatlong[|startindex,1\endindex,1|] = mymat[,j]
	}
	return(mymatlong)
}

real matrix permute_net(real matrix nwadj) {
	nsize = rows(nwadj)
	permutationVec = unorder(nsize)
	return (nwadj[permutationVec, permutationVec])
}
end
	
