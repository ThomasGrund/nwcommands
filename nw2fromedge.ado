capture program drop nw2fromedge
program nw2fromedge
	syntax varlist(min=2 max=3) [if] [, generate(string) project(string) stat(string) xvars * ]
	
	if "`project'" != "" {
		if ("`project'" != "1" & "`project'" != "2") {
			di "{err}Option {bf:project()} has to be either {bf:1} or {bf:2}. No projection executed." 
			local project = ""
		}
	}
	
	if "`stat'" != "" {
		_opts_oneof "sum mean min max minmax" "stat" "`stat'" 6556
	}
	
	if "`generate'" == "" {
		local generate = "_modeid"
	}
	
	local group1 : word 1 of `varlist'
	local group2 : word 2 of `varlist'
	local value : word 3 of `varlist'
		
	qui levelsof `group1'
	local lev_group1 `r(levels)'
	local num_group1 : word count `lev_group1'
	
	qui levelsof `group2'
	local lev_group2 `r(levels)'
	local num_group2 : word count `lev_group2'
	local overlap : list lev_group1 & lev_group2
	
	if "`overlap'" != "" {
		capture confirm numeric variable `group1'
		if _rc == 0 {
			tostring `group1', replace

		}
		capture confirm numeric variable `group1'
		if _rc == 0 {
			tostring `group1', replace

		}
		replace `group1' = "m1_" + `group1'
		replace `group2' = "m2_" + `group2'
	}
	
	preserve
	tempfile dic1
	tempvar temp
	keep `group1'
	gen `temp' = 1
	collapse (mean) `temp', by(`group1')
	sort `group1'
	qui save `dic1', replace
	restore
	
	nwfromedge `group1' `group2' `value' `if', `options' `xvars' undirected
	
	capture drop `group1'
	gen `group1' = _nodelab
	
	_nwsyntax
	local onename "`netname'"
	local onenodes `nodes'
	capture drop `generate'

	qui merge m:n `group1' using `dic1', nogenerate
	
	qui generate `generate' = 1 if `temp' == 1
	qui replace `generate' = 2 if `generate' != 1
	qui drop `group1'
	
	qui if "`project'" != ""  {
		local newname "p1_`onename'"
		if "`project'" == "2" {
			replace `generate' = 3 - `generate'	
			local newname "p2_`onename'"
		}
		nwsort `onename', by(`generate')
		mata: onemodeid = st_data((1,`onenodes'), "`generate'")
		nwtomata, mat(onenet)

		local _stat = 5
		if "`stat'" == "max" {
			local _stat = 2
		}
		if "`stat'" == "mean" {
			local _stat = 3
		}
		if "`stat'" == "sum" {
			local _stat = 4
		}
		if "`stat'" == "minmax" {
			local _stat = 5
		}	
		keep if `generate' == 1
		mata: onenet = onemodeproject(onenet, onemodeid, `_stat')
		mata: onenet
		exit
		
		mata: rows(onenet)
		mata: onenet
		nwset , mat(onenet) name(`newname')
		nwset, detail
		nwsummarize
		di "h2"
		nwname, newlabsfromvar(_nodelab)
		nwdrop `onename'
		capture mata: mata drop onenet
		di "h3"
		nwsym
		di "h33"
		drop _all
		if "`xvars'" != "" {
			di "h34"
			nwload, labelonly
			di "h35"
		}
		else {
			di "h44"
			nwload
		}
		di "h4"
	}
	nwsummarize
end


capture mata: mata drop onemodeproject()
mata:
real matrix onemodeproject(matrix _net, matrix _modeid, scalar _stat) {
	num_m1 = sum(_modeid :== 1)

	N = rows(_net)
	projection = J(num_m1, num_m1, 0)
	
	for (i = 1 ; i < num_m1; i++) {
		k = i + 1
		for (j = k ; j <= num_m1; j++) {
			vec_i = _net[i,.]
			vec_i0 = (vec_i :> 0)
			vec_j = _net[j,.]
			vec_j0 = (vec_j :> 0)
			
			// minmax
			if (_stat == 5){
				temp0 = J(2,N,.)
				temp0[1,.] = vec_i :* vec_i0 :* vec_j0
				temp0[2,.] = vec_j :* vec_i0 :* vec_j0
				temp = colmin(temp0)
			}
			else {
				temp = J(2, (2 * N), 0)
				temp[1,(1..N)] = vec_i :* vec_i0 :* vec_j0
				temp[2,((N+1)..(2*N))] = vec_j :* vec_i0 :* vec_j0
				_editvalue(temp, 0, .)
			}
			
			// minimum
			if (_stat == 1) {
				projection[i,j] = min(temp)
			}
			// maximum
			if (_stat == 2) {
				projection[i,j] = max(temp)
			}
			// mean
			if (_stat == 3) {
				projection[i,j] = mean(temp)
			}
			// sum
			if (_stat == 4) {
				projection[i,j] = sum(temp)
			}
			// minmax
			if (_stat == 5) {
				projection[i,j] = max(temp)
			}	
		}
	}
	_editmissing(projection, 0)
	return(projection)
}
end




