capture program drop nwmixing
program nwmixing
	syntax [anything(name=netname)] , attribute(varname) [eiplot eiplotoptions(string) unvalued plot plotoptions(string) permutations(integer 100) * ]
	nw_syntax `netname', max(1)
	local undirected = ("`directed'" == "false")
	nw_datasync `netname'
	
	tempvar att
	tempname attmat
	capture encode `attribute', generate(`att')
	if _rc != 0 {
		gen `att' = `attribute'
	}
	mata: `attmat' = st_data((1,`nodes'), "`att'")
	
	local attrlab : value label `attribute'
	
	preserve
	nwtoedge `netname', egovars(`attribute') altervars(`attribute')
	capture label val `attribute'_nwego `attrlab'
	capture label val `attribute'_nwalter `attrlab'
	
	di
	local ident = max(length("`netname'"), length("`attribute'")) + 20
	di "{txt}   Network:  {res}`netname'{txt}{col `ident'}Directed: {res}`directed'{txt}"
	di "{txt}   Attribute:  {res}`attribute'{txt}"

	if "`undirected'" != "" {
		di
		di"{txt}       The network is undirected."
		di"{txt}       The table shows two entries for each edge."
	}
	tempname tableres tablecol tablerow
	tab `attribute'_nwego `attribute'_nwalter if `netname' != 0 & `netname' != ., matcell(`tableres') matcol(`tablecol') matrow(`tablerow') `options'
	
	if "`plot'" != "" {
		tabplot `attribute'_nwego `attribute'_nwalter if `netname' != 0 & `netname' != ., horizontal plotregion(margin(b = 0)) `plotoptions'
	}
	
	tempname __nwtable __nwcol __nwrow __nwinternal __nwexternal __nwei_index 
	mata: `__nwtable' = st_matrix("`tableres'")
	mata: `__nwcol' = st_matrix("`tablecol'")
	mata: `__nwrow' = st_matrix("`tablerow'")
	mata: `__nwinternal' = sum(diagonal(`__nwtable'))
	mata: `__nwexternal' = sum(`__nwtable') - `__nwinternal'
	mata: `__nwei_index' = (`__nwexternal' - `__nwinternal') / (`__nwexternal' + `__nwinternal')
	
	mata: st_global("r(netname)", "`netname'")
	mata: st_global("r(attribute)", "`attribute'")
	mata: st_numscalar("r(EI_index)", `__nwei_index')
	mata: st_matrix("r(table)", `__nwtable')
	mata: st_matrix("r(col)", `__nwcol')
	mata: st_matrix("r(row)", `__nwrow')
	
	capture mata: mata drop `__nwtable', `__nwcol', `__nwrow', `__nwinternal', `__nwexternal', `__nwei_index' 

	local EI_index = `r(EI_index)'

	tempname EI_qap out pvalue
	capture _return drop res1
	_return hold res1
	
	qui if `permutations' > 1  {
	
		mata: `EI_qap' = rep_EIvar(`permutations', `netobj'->get_matrix(), `attmat')
		if `EI_index' > 0 {
			mata: `out' = sum(`EI_qap' :>= `EI_index')
		}
		else {
			mata: `out' = sum(`EI_qap' :<= `EI_index')	
		}
		mata: `pvalue' = `out' / `permutations'
		mata: mata drop `out'
		
		drop _all
		getmata EI_simulated = `EI_qap'
		gen EI_observed = `EI_index'
		if "`save'"!= "" {
			di "QAP results saved as: `save'" 
			save "`save'", replace
		}
		
		qui sum EI_simulated
		local xmin = min(`EI_index',r(min))
		local xmax = max(`EI_index',r(max))
		local bandwidth `= 1 / `nodes''
		if "`eiplot'" != "" {
			kdensity EI_simulated, xscale(range(`xmin' `xmax')) title("") bwidth(`bandwidth') ytitle("Density") xtitle("E-I Index") xline(`EI_index',lpattern(dash)) xlabel(#5) note(`"based on `permutations' QAP permutations of network `net1'"') `eiplotoptions'	
		}		
	}
	_return restore res1
	capture mata: st_numscalar("r(EI_pvalue)", `pvalue')
	
	capture mata: mata drop `EI_out' `pvalue' `out'
	capture mata: mata drop `attmat'
	
	di "{txt}   E-I Index: {res}`=round(`r(EI_index)',0.001)'{txt}   p-value: {res}`=round(`r(EI_pvalue)',0.001)'"

	restore
end	

capture mata : mata drop rep_EIvar()

mata:
real matrix rep_EIvar(real scalar reps, real matrix net1, real matrix attr){
	real scalar nsize, total, EI, i
	real matrix intern, extern, same, attrMat, attrMatTr, permutationVec, perm_net
	
	net1
	attr
	
	nsize = cols(net1)
	attrMat = J(nsize, nsize,1) :* attr
	attrMatTr = attrMat'
	same = (attrMat:== attrMatTr)
	net1 = (net1:!=0)
	
	total = J(reps, 1, sum(net1))
	intern = J(reps, 1, 0)
	extern = J(reps, 1, 0)
	
	for (i = 1; i <= reps; i ++) {
		permutationVec = unorder(nsize)
		perm_net = net1[permutationVec, permutationVec]
		intern[i] = sum(perm_net :* same)
	}
	extern = total :- intern
	EI = (extern - intern) :/ (extern + intern)
	return(EI)
}
end
