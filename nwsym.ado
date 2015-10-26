*! Date        : 25oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwsym
program nwsym
	version 9.0
	syntax [anything(name=netname)][, check name(string) vars(string) xvars noreplace mode(string)]
	nw_syntax `netname', max(1)
	
	if "`check'" != "" {
		mata: st_global("r(is_symmetric)", `netobj'->check_symmetry())
		exit
	}

	if "`mode'" == "" {
		local mode = "max"
	}
	
	nw_optsoneof "max min sum mean" "mode" "`mode'" 6555

	if ("`replace'" != ""){
		// generate valid network name and valid varlist
		if "`name'" == "" {
			local name "_sym_`netname'"
		}
		
		// generate a new network
		nwduplicate `netname', name(`name')
		local netname "`r(duplicate)'"
	}

	nw_syntax `netname'
	mata: `netobj'->symmetrize("`mode'")
end
