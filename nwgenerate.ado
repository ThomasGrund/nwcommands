capture program drop nwgenerate
program nwgenerate
	local arg `0'
	gettoken arg options: arg, parse(",") bind
	if "`options'" != "" {
		local options: subinstr local options "," " " 
	}

	gettoken netname netexp: arg, parse("=")
	local netexp: subinstr local netexp "if" "#"
	
	gettoken dump opts: arg, parse(",") bind
	if "`opts'" != "" {
		local 0 `opts'
		syntax [, xvars vars(string) replace]
	}
	local netname = trim("`netname'")
	

	// replace the network if it exists already
	if (strpos("`options'", "replace")!=0){
		capture nwdrop `netname'
		local options ""
	}
		
	capture _nwsyntax_other `netname'
	if _rc == 0 {
		di "{err}Network {bf:`netname'} already exists. Change {it:netname} or specify option {bf:replace}.{txt}"
		error 6099
	}
	
	// if condition
	gettoken netexp ifcond: netexp, parse("#")
	local ifcond: subinstr local ifcond "#" "if"
		
	// check if network or variable should be created
	
	local netexp : subinstr local netexp "("  "( "	
	
	/*gettoken job jobrest: netexp, parse("(")
	local job = trim("`job'")
	local job = substr("`job'", 2,.)
	local selectjob : word 1 of `job'*/
	
	local selectjob : word 2 of `netexp'
	local nwgenopt "duplicate( dyadprob( geodesic( subset( homophily( lattice( path( permute( pref( random( reach( ring( small( transpose( evcent( context( degree( outdegree( indegree( isolates( components( lgc( clustering( closeness( farness( nearness( between("
	local whichjob : list  nwgenopt & selectjob
	local netfcn : word count `whichjob'
	
	// no varfcn or netfcn
	qui if `netfcn' == 0 {
	
		capture nwname `netname'
		if _rc == 0 {
			di "{err}network {it:`netname'} already defined"
			error 6004
		}
	
		// get rid of first equal sign and check for single generator
		local netexp = substr(trim("`netexp'"),2,.)
		if (substr("`netexp'",1,1)=="_") {
			local netexp "(`netexp')"
		}
	

		// evaluate network expression
		_nwevalnetexp `netexp' % _genmat
		local nodes = r(nodes)
	
		// check if new network id directed
		mata: st_numscalar("r(sym)", issymmetric(_genmat))
		if (r(sym) == 1){
			local undirected "undirected"
		}
	
		nwrandom `nodes', prob(0) name(`netname') `undirected' `options' xvars `vars'
		nwreplacemat `netname', newmat(_genmat) `vars'
	
		mata: st_rclear()
		nwname `netname'
		mata: st_global("r(netexp)", "`netexp'")
		mata: mata drop _genmat
		
		if "`ifcond'" != "" {
			nwkeep `netname' `ifcond'
		}
	}
	
	// generate variable or network based on function
	qui else  {
		// get whatever is inside parenthesis
		local start = strpos("`netexp'", "(")
		local length2 = length("`netexp'")
		local length = `length2' - `start' - 1
		//local length = (strpos("`netexp'",")")) - `start' 
		local subopt = substr("`netexp'", `=`start' + 1', `length')
		
		local optionsold `options'
		
		local 0 `subopt'
		syntax [anything(name=sub1)] [, *]
		local sub2 `options'
			
		/// NETWORK PRODUCING FUNCTIONS
		/////////
		
		// nwduplicate shortcut
		qui if "`whichjob'" == "duplicate(" {
			noi _nwsyntax_other `sub1', max(9999) name("othername")
			nwduplicate `sub1', `sub2' name(`netname') `oldoptions'
		}	
		
		// nwduplicate shortcut
		qui if "`whichjob'" == "subset(" {
			noi _nwsyntax_other `sub1', max(9999) name("othername")
			nwsubset `sub1' `ifcond', `sub2' name(`netname') `oldoptions'
		}

		// nwdyadprob shortcut
		qui if "`whichjob'" == "dyadprob(" {
			noi _nwsyntax_other `sub1', max(9999) name("othername")
			nwdyadprob `sub1', `sub2' name(`netname') `oldoptions'
		}	
		
		// nwgeodesic shortcut
		qui if "`whichjob'" == "geodesic(" {
			noi _nwsyntax_other `sub1', max(9999) name("othername")
			nwgeodesic `sub1', `sub2' name(`netname') `oldoptions'
		}
		// nwgeodesic shortcut
		qui if "`whichjob'" == "homophily(" {
			noi _nwsyntax_other `sub1', max(9999) name("othername")
			nwhomophily `sub1', `sub2' name(`netname') `oldoptions'
		}
		// nwlattice shortcut
		qui if "`whichjob'" == "lattice(" {
			nwlattice `sub1', `sub2'name(`netname') `oldoptions'
		}	
		// nwlattice shortcut
		qui if "`whichjob'" == "path(" {
			noi _nwsyntax_other `sub1', max(9999) name("othername")
			nwpath `subopt', name(`netname') `oldoptions'
		}
		// nwlattice shortcut
		qui if "`whichjob'" == "permute(" {
			noi _nwsyntax_other `sub1', max(9999) name("othername")
			nwpermute `sub1', `sub2' name(`netname') `oldoptions'
		}	
		// nwpref shortcut
		qui if "`whichjob'" == "pref(" {
			nwpref `sub1', `sub2' name(`netname') `oldoptions'
		}	
		// nwrandom shortcut
		qui if "`whichjob'" == "random(" {
			nwrandom `sub1', `sub2' name(`netname') `oldoptions'
		}	
		// nwreach shortcut
		qui if "`whichjob'" == "reach(" {
			noi _nwsyntax_other `sub1', max(9999) name("othername")
			nwreach `sub1', `sub2' name(`netname') `oldoptions'
		}	
		// nwring shortcut
		if "`whichjob'" == "ring(" {
		noi di "nwring `subopt', name(`netname') `options'"
			nwring `sub1', `sub2' name(`netname') `oldoptions'
		}	
		// nwsmall shortcut
		qui if "`whichjob'" == "small(" {
			nwsmall `sub1', `sub2' name(`netname') `oldoptions'
		}
		// nwtranspose shortcut
		qui if "`whichjob'" == "transpose(" {
			noi _nwsyntax_other `sub1', max(9999) name("othername")
			nwtranspose `sub1', `sub2' name(`netname') `oldoptions'
		}	
		
		/// VARIABLE PRODUCING FUNCTIONS
		/////////
		
		// nwclustering shortcuts
		qui if "`whichjob'" == "clustering(" {
			noi _nwsyntax_other `sub1'
			nwclustering `subopt', gen(`netname') `options'
		}
		
		// nwcloseness shortcuts
		qui if "`whichjob'" == "closeness(" {
			tempvar _t1 _t2
			noi _nwsyntax_other `sub1'
			nwcloseness `sub1', `sub2' gen(`netname' `_t1' `_t2') `options'
		}
		qui if "`whichjob'" == "farness(" {
			tempvar _t1 _t2
			noi _nwsyntax_other `sub1'
			nwcloseness `sub1', `sub2' gen(`_t1' `netname' `_t2') `options'
		}
		qui if "`whichjob'" == "nearness(" {
			tempvar _t1 _t2
			noi _nwsyntax_other `sub1'
			nwcloseness `sub1', `sub2' gen(`_t1' `_t2' `netname') `options'
		}
		
		// nwcomponents shortcuts
		if "`whichjob'" == "components(" {
			noi _nwsyntax_other `sub1'	
			qui nwcomponents `sub1', `sub2'gen(`netname') `options'
		}
		if "`whichjob'" == "lgc(" {
			noi _nwsyntax_other `sub1'
			qui nwcomponents `sub1', `sub2' gen(`netname') lgc `options'
		}
		
		// nwdegree shortcuts
		qui if "`whichjob'" == "isolates(" {
			tempvar _t1 
			noi _nwsyntax_other `sub1'
			nwdegree `sub1', `sub2' isolates gen(`_t1') `options'
			rename _isolate `netname' 
			capture drop *`_t1'
		}
		qui if "`whichjob'" == "indegree(" {
			tempvar _t1 
			noi _nwsyntax_other `sub1'
			nwdegree `sub1', `sub2' gen(`netname' `_t1') `options'
			capture confirm variable _in`netname'
			if _rc == 0 {
				rename _in`netname' `netname'
				drop _out`netname'
			}
		}
		qui if "`whichjob'" == "outdegree(" {
			tempvar _t1
			noi _nwsyntax_other `sub1'		
			nwdegree `sub1', `sub2' gen(`netname' `_t1') `options'
			capture confirm variable _out`netname'
			if _rc == 0 {
				rename _out`netname' `netname'
				drop _in`netname'
			}
		}
		qui if "`whichjob'" == "degree(" {
			tempvar _t1
			noi _nwsyntax_other `sub1'
			nwdegree `sub1', `sub2' gen(`netname' `_t1') `options'
			capture confirm variable _out`netname'
			if _rc == 0 {
				rename _out`netname' `netname'
				drop _in`netname'
			}
		}
		
		// nwbetween shortcuts
		if "`whichjob'" == "between(" {
			noi _nwsyntax_other `sub1'
			nwbetween `sub1', `sub2'  generate(`netname') `options'
		}
		
		// nwcontext shortcuts
		if "`whichjob'" == "context(" {
			noi _nwsyntax_other `sub1'
			nwcontext `sub1', `sub2'  generate(`netname') `options'
		}
		
		// nwevcent shortcuts
		if "`whichjob'" == "evcent(" {
			noi _nwsyntax_other `sub1'
			nwevcent `sub1', `sub2'  generate(`netname') `options'
		}
		
	}

	capture nwdrop _temp*
end

	
	
	
	
	
	

	
