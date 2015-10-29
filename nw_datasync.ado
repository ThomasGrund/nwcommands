capture program drop nw_datasync
program nw_datasync
	syntax [anything(name=netname)] [, overwrite generate(string)]
	unw_defs
	nw_syntax `netname'
	set more off
	tempfile f
	tempname __nwnodename
	tempname __nwindex
	
	if "`overwrite'" != "" {
		capture drop `nw_nodename'
		mata: `__nwnodename' = (`netobj'->get_nodenames())'
		qui getmata `nw_nodename' = `__nwnodename', force replace
		exit
	}

	preserve
	drop _all
	mata: `__nwnodename' = (`netobj'->get_nodenames())'
	qui getmata `nw_nodename' = `__nwnodename', force replace
	qui gen `__nwindex' = _n
	qui save `f', replace
	restore
	
	capture confirm variable `nw_nodename'
	qui if (_rc != 0) {
		gen str40 `nw_nodename' = ""
	}

	tempvar current
	qui capture drop `generate'
	qui merge n:1 (`nw_nodename') using `f', generate(`current')
	qui replace `current' = (`current' != 1)
	gsort -`current' +`__nwindex'
	qui if "`generate'" != "" {
		capture drop `generate'
		gen `generate' = (`current'==1)
	}
	
	capture mata: mata drop `__nwnodename'
	capture mata: mata drop `__nwindex'
end
