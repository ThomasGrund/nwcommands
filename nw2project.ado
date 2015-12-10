capture program drop nw2project
program nw2project
	syntax [anything(name=netname)] [, name(string) modeid(string) level(string) stat(string) xvars * ]
	_nwsyntax `netname'
	
	if "`modeid'" == "" {
		local modeid = "_modeid"
	}
	qui sum `modeid'
	if (r(min) != 1 & r(max) != 2){
		di "{err}Variable {bf:`modeid'} can only have values 1 and 2"
		exit
	}
	
	local onename "`netname'"
	local onenodes `nodes'
	local newname "p1_`onename'"
	if "`level'" == "2" {
		replace `modeid' = 3 - `modeid'	
		local newname "p2_`onename'"
	}
	if "`name'" != "" {
		local newname "`name'"
	}
	
	qui nwload `netname', labelonly
	qui nwsort `onename', by(`modeid') attribute(_nodelab)
	mata: onemodeid = st_data((1,`onenodes'), "`modeid'")
	nwtomata `netname', mat(onenet)
		
	local _stat = 5
	if "`stat'" == "" {
		local _stat = 0
	}
	if "`stat'" == "min" {
		local _stat = 1
	}
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
	
	qui keep if `modeid' == 1
	mata: onenet = onemodeproject(onenet, onemodeid, `_stat')
	nwset , mat(onenet) name(`newname')
	nwname, newlabsfromvar(_nodelab)
	qui nwname
	nwname, newvars(`r(labs)')
	nwdrop `onename'
	capture mata: mata drop onenet
	nwsym
	drop _all
	qui if "`xvars'" != "" {
		nwload, labelonly
	}
	else {
		nwload
	}
	mata: mata drop onemodeid
end


capture mata: mata drop onemodeproject()
mata:
real matrix onemodeproject(matrix _net, matrix _modeid, scalar _stat) {
	num_m1 = sum(_modeid :== 1)
	
	N = rows(_net)
	projection = J(num_m1, num_m1, 0)
	
	// ignore tie values for projection
	if (_stat == 0){
		_netbin = _net :/ _net
		_editmissing(_netbin, 0)
		projection = select((_netbin * _netbin), (_modeid:==1))
		projection = select(projection, (_modeid:==1)')
		_diag(projection,0)
	}
	
	else {
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
	}
	_editmissing(projection, 0)
	return(projection)
}
end
