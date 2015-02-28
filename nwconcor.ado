capture program drop nwconcor
program nwconcor
	syntax [anything(name=netname)] [, blocks(integer 2) generate(string) * ]
	_nwsyntax `netname', max(1) 
	
	if "`generate'" == "" {
		local generate = "_eqvclass"
	}
	capture drop `generate'
	
	nwconcor_level0 `netname',  generate(`generate') `options'
	
	if `blocks' > 2 {
	
		tab `generate' , matcell(tabresult) matrow(tabvalue)
		local maxrow = 1
		local rows = `rowsof(tabresult)'
		forvalues i = 1/`rows' {
			if (tabresult[`i',1] > tabresult[`maxrow',1]){
				local maxrow = `i'
			}
		}
		local maxvalue = tabvalue[`maxrow',1]
		local ifcond "(`generate' ==  `maxvalue')"
		
		tempvar ifcond_var
		gen `ifcond_var' = `ifcond' 
		mata: st_view(ifcond=., (1::`nodes'), "`ifcond'")
		mata: st_view(eqv=., (1::`nodes'), "`generate'")
		mata: st_select(new_eqv=., eqv, ifcond)
		
		nwgen __temp_if = `netname' if `ifcond'
		tempvar temp_eqv
		nwconcor_level0 __temp_if, generate(`temp_eqv') blocks(2) `options'
		mata: st_view(temp_eqv=.,(1::`nodes'), "`temp_eqv'")
		mata: new_eqv = temp_eqv
	}
	


capture program drop nwconcor_level0
program nwconcor_level0
	syntax [anything(name=netname)] [, generate(string) iter(integer 10) context(string) name(string) image(name)]
	_nwsyntax `netname', max(1) 
	
	if "`generate'" == "" {
		local generate = "_eqvclass"
	}
	if "`name'" == "" {
		local name = "_concor"
	}
	nwvalidate `name'
	local name = r(validname)
	
	local neighborhood = 1
	if "`context'" == "incoming" {
		local neighborhood = 2
	}
	if "`context'" == "both" {
		local neighborhood = 3
	}
	
	nwtomata `netname', mat(onenet)
	forvalues i = 1/ `iter' {
		mata: onenet = correlate_nodes(onenet, `neighborhood')
	}
	//mata: _editvalue(onenet, -1, 0)
	mata: _diag(onenet,0)
	mata: onenet = round(onenet)
	mata: _editvalue(onenet, -1, 0)
	nwset, mat(onenet) name(`name')
	nwcomponents `name', generate(`generate')
end


capture mata mata drop correlate_nets_rep()
capture mata mata drop correlate_nets()
capture mata: mata drop correlate_nodes()
mata:

real matrix correlate_nodes(real matrix net, scalar outinboth){

	C = J(rows(net), cols(net), 0)
	for(i = 1; i<= rows(net); i++){
		for(j = 2; j<= cols(net); j++){
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
					Corr[2,1] = (1 - 2 * (sum((i_outvec :- j_outvec):^2) / rows(i_outvec)))
				}
				C[i,j] = Corr[2,1]
			}
			if (outinboth == 2) {
				temp = J(rows(i_invec), 2, 0)
				temp[.,1] = i_intvec
				temp[.,2] = j_invec
				Corr = correlation(temp)
				
				if (Corr[2,1]==.){
					Corr[2,1] = (1 - 2 * (sum((i_invec :- j_invec):^2) / rows(i_invec)))
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
					Corr[2,1] = (1 - 2 * (sum((i_invec :- j_invec):^2) / rows(i_invec)))
				}
				C[i,j] = Corr[2,1]
			}
		}
	}
	return(C)
}


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
	r = rows(net1)
	c = cols(net1)
	Z = J(r,c,1) - I(r,c)
	temp = J((r * (c - 1)),2, 0)
	temp[.,1] = select(vec(net1), vec(Z))
	temp[.,2] = select(vec(net2), vec(Z))
	corr = correlation(temp)
	return(corr[2,1])
}
end

