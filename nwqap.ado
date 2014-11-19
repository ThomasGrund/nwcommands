*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwqap	
program nwqap
syntax [anything (name=formula)] [, detail type(string) mode(string) PERMutations(integer 500) save(string) ]
    set more off

	mata: st_rclear()
	
	if "" == "" {
		local type = "logit"
	}
	
	// Get general information.
	local vars = wordcount("")
	if ( < 2) {
		di "{err}Formula wrongly specified."
		error 6057
	}
	
	local net = word("", 1)
	_nwsyntax , max(1)	
	nwtomata , mat(dvnet)
	
	// Generate dataset in long format.
	mata: datalong = J(( * ),, 0)
	
	local i = 1
	local t = 1
	
	local prefix ""
	
	foreach entry in  {
		nwvalidate 
		// DV or IV is network
		if (r(exists) == "true") {
			nwname 
			local nextname ""
			if r(nodes) !=  {
				di "{err}Networks of different size."
				error 6056
			}
			nwtomata , mat(onenet)
			mata: _diag(onenet, J(rows(onenet), 1, .))
			mata: temp = transformIntoLong(onenet)
			mata: datalong[,] = temp
			local i =  + 1
			local prefix " "
		}
		// Assume IV to be a variable.
		else {
			confirm variable 
			// Make network out of IV.
			tokenize 
			nwexpand , name(_tempexpand) mode("") nodes()
			nwtomata _tempexpand, mat(onenet)
			mata: _diag(onenet, J(rows(onenet), 1, .))
			mata: temp = transformIntoLong(onenet)
			mata: datalong[,] = temp
			local i =  + 1
			nwdrop _tempexpand
			if "" == "" {
				local prefix " same_"
			}
			else {
				local prefix " _"
			}
			local t =  + 1
		}
	}
		
	preserve
	drop _all
	local obs =  * 
	qui set obs 
	qui foreach entry in  {
		gen  = .
	}
	mata: st_store(.,.,datalong)
		
	tempname memhold
    tempfile results
	
	qui gen _original = 
	qui replace  = .
	
	quietly postfile   using , replace
	
	// Run regression on permutations.
	set more off
	di 
	local perm_running 1
	qui forvalues j = 1/ {
		if  == 1 {
			noisily di "{txt}Permutation: 1 out of "
		}
		if  / 50 >=  {
			noisily di "{txt}Permutation:  out of "
			local perm_running =  + 1
		}
		mata: perm_net = permute_net(dvnet)
		mata: net_long = transformIntoLong(perm_net)
		mata: st_store(., "", net_long)
		 
	
		mat temp_coeff = e(b)
		local post_txt = ""
		local varsminus =  - 1
		forvalues i = 1/ {
			local post_txt = " ()"
		}
		local post_txt ="() "
		post  
	}
	postclose 
	
	// Run regression with original data.
	qui replace  = _original
	if "" != "" {
		 
	}
	else {
		quietly  
	}
	mat reg_results = e(b)
	
	// Calculate p-values.
	use , clear
	if "" != "" {
		save "", replace
	}	
	matrix pvalues = J(1, , .)
	local k = 1
	qui foreach entry in  {
		if ("" == "") {
			local orig_result = reg_results[1,]
		}
		else {
			local orig_result = reg_results[1,]
		}
		
		local novariation = "false"	
		sum 
		if ( == 0) {
			local novariation = "true"
			di ""
		}
		local diff = abs(r(mean) - )
		local upper_mark = r(mean) + 
		local lower_mark = r(mean) - 
		count if  > 
		local upper = r(N)
		count if  < 
		local lower = r(N)	
		local outer =  + 	
		count
		local total = r(N)
		local p =  / 	
		if "" == "true" {
			local p = "."
		}
		if ("" == "") {
			mat pvalues[1,] = 
		}
		else {
			mat pvalues[1,] = 
			local k =  + 1
		}
	}	
	restore
	
	//  Display results.
	local max_l = 0
	tokenize ""
	if  < 20 {
		local max_l = 20
	}
	di 
	di 
	qui nwinfo 
	local dyads =  *  -  
	di "{txt}Multiple Regression Quadratic Assignment Procedure"
	di
	di "{txt}  Estimation{col 25}={res}  QAP" 
	di "{txt}  Regression{col 25}={res}  "
	di "{txt}  Permutations{col 25}={res}  "  
	di "{txt}  Number of vertices{col 25}=  {res}" 
	if r(directed) == "true" {
		di "{txt}  Number of arcs{col 25}=  {res}" 
	}
	if r(directed) == "false" {
		di "{txt}  Number of edges{col 25}=  {res}"
	}
	//di "{txt}  Number of dyads{col 25}=  {res}"
	di 
	di "{txt}{hline 3}{c TT}{hline 25}"
	di "{col 2}{ralign 1:}{col 4}{c |}{col 11}Coef.{col 20}P-value"
	di "{hline 3}{c +}{hline 25}"
	local constant = round(reg_results[1,], 0.000001)
	
	forvalues k=2/{
		local coeff = 
		local pvalue = 
		di as text "{txt}{col 2}{ralign 1:}{col 4}{c |}{col 5}{ralign 11:{res}}{col 20}{ralign 5:}"
	}
	di "{txt}{col 2}{ralign 1:_cons}{col 4}{c |}{col 5}{ralign 11:{res}}"
	di "{txt}{hline 3}{c BT}{hline 25}"
	di "{error}"
	
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
	
