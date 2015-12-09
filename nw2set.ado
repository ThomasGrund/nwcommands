capture program drop nw2set
program nw2set
	syntax [varlist (default=none)][, generate(string) rownames(varname) xvars name(string) clear nwclear edgelist name(string) vars(string) labs(string) mat(string) ]
	set more off

	if "`clear'" != "" {
		nwdrop _all, netonly
	}
	if "`nwclear'" != "" {
		nwclear
	}
	if "`generate'" == "" {
		local generate = "_modeid"
	}
	
	if "`edgelist'" != "" {
		qui foreach var in `varlist' {
			tostring(`var'), replace
		}
		nw2fromedge `varlist', generate(`generate') `xvars' name(`name') 
		exit
	}
	
	capture mata: mata drop M
	if "`mat'" != "" {
		mata: M = J((rows(`mat') + cols(`mat')), (rows(`mat') + cols(`mat')), 0)
		mata: M[((cols(`mat') + 1) :: rows(M)), (1:: cols(`mat'))] = `mat'
		mata: M = M + M'
	}
	// matrix given in varlist
	else {
		tempname mat
		qui putmata `mat' = (`varlist')
		mata: M = J((rows(`mat') + cols(`mat')), (rows(`mat') + cols(`mat')), 0)
		mata: M[((cols(`mat') + 1) :: rows(M)), (1:: cols(`mat'))] = `mat'
		mata: M = M + M'
		mata: mata drop `mat'
		local rows ""
		forvalues i=1/`=_N' {
			if "`rownames'" != "" {
				local rows "`rows' `=`rownames'[`i']'"
			}
			else {
				local rows "`rows' n`i'"
			}
		}
		local l "`varlist' `rows'" 
	}
	if "`labs'" != "" {
		local l "`labs'"
	}
	local mode1 : word count `varlist'
	qui nwset, mat(M) labs(`l') name(`name') undirected `xvars'
	qui nwload, labelonly
	capture drop `generate'
	capture drop `varlist'
	generate `generate' = 2 - (_n <= `mode1')
	mata: mata drop M
end
	
	
	
	
	
