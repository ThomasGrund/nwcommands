*! Date        : 29oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwtabulate
program nwtabulate
	syntax [anything(name=netname)] [, *]
	nw_syntax `netname', max(2)

	if `networks' == 1 {
		nwtab1 `netname', `options'
	}
	if `networks' == 2 {
		nwtab2 `netname', `options'
	}
	if `networks' > 2 {
		di "{err}Maximum two networks allowed.{txt}"
		exit
	}
end

capture program drop nwtab1
program nwtab1
	
	syntax [anything] , [selfloop *]
	preserve
	
	nw_syntax `anything'
	if "`directed'" == "false" {
		local upper = "upper"
	}
	nw_edgelabs `anything'
	local edgelabs r(edgelabs)
	
	nwtoedge `netname', `upper'
	mata: mata desc
	exit
	
	local ident = length("`netname'") + 20
	di
	di "{txt}   Network:  {res}`netname'{txt}{col `ident'}Directed : {res}`directed'{txt}"
	di "{txt}                           {txt}{col `ident'}Selfloops: {res}`selfloops'{txt}"
	capture label def elab `edgelabs'
	capture label val `netname' elab
	tab `netname', `options'
	restore
end


capture program drop nwtab2
program nwtab2
	syntax anything(name=netname) [, eiplot eiplotoptions(string) unvalued plot plotoptions(string) permutations(integer 100) *]
		
	if "`plot'" != "" {
		capture which tabplot
		if _rc != 0 {
			ssc install tabplot
		}
	}
	
	local netname0 `netname'
	nw_syntax `netname', max(2) min(2)
	local upper = "upper"
	foreach net in `netname' {
		nw_syntax `net'
		if "`directed'" == "true" {
			local upper = ""
		}
	}
	
	preserve
	nwtoedge `netname0', `upper'
	
	local net1: word 1 of `netname0'
	nw_edgelabs `net1'
	capture label def elab1 `r(edgelabs)'
	capture label val `net1' elab1
	
	local net2: word 2 of `netname0'
	nw_edgelabs `net2'
	capture label def elab2 `r(edgelabs)'
	capture label val `net2' elab2

	local ident = length("`netname'") + 20
	di
	nw_syntax `net1'
	local netobj1 `netobj'
	di "{txt}   Network1:  {res}`net1'{txt}{col `ident'}Directed : {res}`directed'{txt}"
	di "{txt}                           {txt}{col `ident'}Selfloops: {res}`selfloops'{txt}"
	nw_syntax `net2'
	local netobj2 `netobj'
	di "{txt}   Network2:  {res}`net2'{txt}{col `ident'}Directed : {res}`directed'{txt}"
	di "{txt}                           {txt}{col `ident'}Selfloops: {res}`selfloops'{txt}"

	tempname tableres tablecol tablerow
	tabulate `netname0', matcell(`tableres') matcol(`tablecol') matrow(`tablerow') `options'
	
	if "`plot'" != "" {
		tabplot `net1' `net2', horizontal plotregion(margin(b = 0)) `plotoptions'
	}
	
	tempname __nwtable __nwcol __nwrow __nwinternal __nwexternal __nwei_index 
	mata: `__nwtable' = st_matrix("`tableres'")
	mata: `__nwcol' = st_matrix("`tablecol'")
	mata: `__nwrow' = st_matrix("`tablerow'")
	mata: `__nwinternal' = sum(diagonal(`__nwtable'))
	mata: `__nwexternal' = sum(`__nwtable') - `__nwinternal'
	mata: `__nwei_index' = (`__nwexternal' - `__nwinternal') / (`__nwexternal' + `__nwinternal')
	
	mata: st_global("r(netname1)", "`net1'")
	mata: st_global("r(netname2)", "`net2'")
	mata: st_numscalar("r(EI_index)", floatround(`__nwei_index'))
	mata: st_matrix("r(table)", `__nwtable')
	mata: st_matrix("r(col)", `__nwcol')
	mata: st_matrix("r(row)", `__nwrow')
	
	capture mata: mata drop `__nwtable', `__nwcol', `__nwrow', `__nwinternal', `__nwexternal', `__nwei_index' 
	
	local EI_index = `r(EI_index)'

	tempname EI_qap out pvalue
	capture _return drop res1
	_return hold res1
	
	qui if `permutations' > 1  {

		mata: `EI_qap' = rep_EInet(`permutations', `netobj1'->get_matrix(), `netobj2'->get_matrix())
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
	capture mata: st_numscalar("r(EI_pvalue)", floatround(`pvalue'))

	capture mata: mata drop `EI_out' `pvalue' `out'
	di "{txt}   E-I Index: {res}" _continue
	di round(float(`r(EI_index)'),0.001) _continue
	di "{txt} p-value: {res}" _continue
	di round(float(`r(EI_pvalue)'),0.001)

	restore

end

capture mata : mata drop rep_EInet()

mata:
real matrix rep_EInet(real scalar reps, real matrix net1, real matrix net2) {
	real scalar nsize, total, EI, i
	real matrix intern, extern, permutationVec, perm_net
	
	net1 = (net1:!=0)
	nsize = cols(net1)
	
	total = nsize * (nsize - 1)
	intern = J(reps, 1, 0)
	extern = J(reps, 1, 0)
	
	for (i = 1; i <= reps; i ++) {
		permutationVec = unorder(nsize)
		perm_net = net1[permutationVec, permutationVec]
		intern[i] = sum(perm_net :== net2)
	}
	extern = total :- intern
	EI = (extern :- intern) :/ (extern :+ intern)
	return(EI)
}

end

