capture program drop nwtostata
program nwtostata
version 9
syntax, mat(string) [ gen(namelist min=1) stub(string) ]

	mata: st_numscalar("r(rows)", rows(`mat'))
	local rows = r(rows)
	if `rows' > `=_N' {
		set obs `rows'
	}
	opts_exclusive "`"`gen'"' `sub'"
	
	if "`gen'" != "" & "`stub'" != "" {
		dis as error "Either option gen or option stub needs to be specified, but not both."
		error 184
	}
	
	
	if "`gen'" == "" & "`stub'" == "" {
		dis as error "Either option gen or option stub needs to be specified."
		error 198
	}

	if "`gen'" != "" {
		foreach x of newlist `gen' {
			quietly gen `x' = .
		}
		mata: st_view(nwtostataview=.,(1,rows(`mat')),tokens("`gen'"))
	}
	
	if "`stub'" != "" {
		mata: st_numscalar("r(cols)", cols(`mat'))
		local cols = r(cols)
		forvalues i = 1/`cols' {
			quietly gen `stub'`i' =.
		}
		unab vars : `stub'*
		mata: st_view(nwtostataview=.,(1,rows(`mat')),tokens("`vars'"))
	}
	mata: nwtostataview[.,.] = `mat'
	capture quietly compress `gen'
	capture quietly compress `stub'*
	mata: mata drop nwtostataview
end
