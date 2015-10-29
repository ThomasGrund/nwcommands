*! Date        : 28oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwtoedge
program nwtoedge
	version 9
	syntax [anything(name=netname)][, compress upper egovars(varlist) altervars(varlist)  ///
	ego(name) alter(name) full] 

	unw_defs
	nw_syntax `netname', max(9999)
	local nets `netname'
	
	if "`ego'" == "" {
		local ego = "_nwego"
	}
	if "`alter'" == "" {
		local alter = "_nwalter"
	}	

	foreach net in `nets' {
		nw_datasync `net'
	}

	qui if "`egovars'" != "" {
		preserve
		tempfile fromfile
		keep `nw_nodename' `egovars' 
		foreach var of varlist `egovars' {
			rename `var' `var'`ego'
		}
		save `fromfile'
		restore
	}
	
	qui if "`altervars'" != "" {
		preserve
		tempfile tofile
		keep `nw_nodename' `altervars'
		foreach var of varlist `altervars' {
			rename `var' `var'`alter'
		}
		save `tofile'
		restore
	}
	
	local i = 0
	qui foreach net in `nets' {
		nw_syntax `net'
		tempfile __nwedgelist`i'
		if "`upper'" != "" & "`directed'" == "true" {
			noi di "{txt}Warning! Network {res}`net'{txt} is directed. Option {res}upper{txt} surpressed." 
		}
		mata: __nwedgelist`i' = (`netobj'->get_edgelist(("`upper'" != "" & "`directed'" == "false")))
		preserve
		drop _all
		getmata (`ego' `alter' `net') = __nwedgelist`i', force
		destring `net', replace force
		mata: mata drop __nwedgelist`i'
		save `__nwedgelist`i''
		restore
		local i = `i' + 1
	}
	
	drop _all
	use `__nwedgelist0'

	qui forvalues j = 1/`=`i'-1' {
		merge m:n (`ego' `alter') using `__nwedgelist`j'', nogenerate
	}
	
	qui if "`egovars'" != "" {
		capture drop `nw_nodename'
		gen `nw_nodename' = `ego'
		merge m:n (`nw_nodename') using `fromfile', nogenerate 
	}

	qui if "`altervars'" != "" {
		capture drop `nw_nodename'
		gen `nw_nodename' = `alter'
		merge m:n (`nw_nodename') using `tofile', nogenerate 
	}
	capture drop `nw_nodename'
	sort `ego' `alter'
	
	qui if "`compress'" != "" {
		tempvar t
		gen `t' = 0
		foreach net in `nets' {
			replace `t' = `t' + abs(`net')
		}
		drop if `t' == 0
	}
	
	foreach net in `nets' {
		capture drop if `net' == `missing2'
	}

end	
