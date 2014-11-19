*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwtostata
program nwtostata
version 9
syntax, mat(string) [ gen(namelist min=1) stub(string) ]

	mata: st_numscalar("r(rows)", rows())
	local rows = r(rows)
	if  > 15 {
		set obs 
	}
	opts_exclusive "`""' "
	
	if "" != "" & "" != "" {
		dis as error "Either option gen or option stub needs to be specified, but not both."
		error 184
	}
	
	
	if "" == "" & "" == "" {
		dis as error "Either option gen or option stub needs to be specified."
		error 198
	}

	if "" != "" {
		foreach x of newlist  {
			quietly gen  = .
		}
		mata: st_view(nwtostataview=.,(1,rows()),tokens(""))
	}
	
	if "" != "" {
		mata: st_numscalar("r(cols)", cols())
		local cols = r(cols)
		forvalues i = 1/ {
			quietly gen  =.
		}
		unab vars : *
		mata: st_view(nwtostataview=.,(1,rows()),tokens(""))
	}
	mata: nwtostataview[.,.] = 
	capture quietly compress 
	capture quietly compress *
	mata: mata drop nwtostataview
end
