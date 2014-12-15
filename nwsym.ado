*! Date        : 24aug2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop nwsym
program nwsym
	version 9.0
	syntax [anything(name=netname)][, check name(string) vars(string) xvars noreplace mode(string)]
	_nwsyntax `netname', max(1)

	local symname = trim("`netname'")
	
	if "`check'" != "" {
		nwtomata `symname', mat(symnet)
		mata: st_rclear()
		mata: st_global("r(name)","`symname'")
		mata: st_numscalar("r(is_symmetric)", (symnet == symnet'))
		if `r(is_symmetric)' == 1 {
			mata: st_global("r(is_symmetric)", "true")
		}
		else {
			mata: st_global("r(is_symmetric)", "false")
		}
		mata: mata drop symnet
		exit
	}

	if "`mode'" ! == "" {
		local mode = "max"
	}
	_opts_oneof "max min sum mean" "mode" "`mode'" 6555

	
	if ("`replace'" != ""){
		// generate valid network name and valid varlist
		if "`name'" == "" {
			local name "_sym_`netname'"
		}
		
		// generate a new network
		nwduplicate `netname', name(`name')
		local symname "`name'"
	}
	
	// get symmetry
	nwtomata `symname', mat(symnet)
	
	if ("`mode'" == "sum") {
		mata: symnet = symnet  + symnet'
	}
	if ("`mode'" == "mean") {
		mata: symnet = (symnet  + symnet'):/2
	}
	if ("`mode'" == "max") {
		mata: sym1 = symnet
		mata: sym2 = symnet'
		mata: res2 = sym2
		mata: res2 = (sym2 :> sym1):* res2
		mata: res1 = sym1
		mata: res1 = (sym1 :>= sym2):* res1
		mata: symnet = res1 + res2
		mata: mata drop sym1 sym2 res1 res2
	}
	if ("`mode'" == "min") {
		mata: sym1 = symnet
		mata: sym2 = symnet'
		mata: res2 = sym2
		mata: res2 = (sym2 :< sym1):* res2
		mata: res1 = sym1
		mata: res1 = (sym1 :<= sym2):* res1
		mata: symnet = res1 + res2
		mata: mata drop sym1 sym2 res1 res2
	}
	
	mata: _diag(symnet,0)
	nwreplacemat `symname', newmat(symnet)
	nwname `symname', newdirected(false)
	mata: st_rclear()
	mata: mata drop symnet
end
