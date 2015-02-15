capture program drop nwgenerate
program nwgenerate
	local arg ="`0'"
	gettoken arg options: arg, parse(",") bind
	if "`options'" != "" {
		local options = substr("`options'", 2,.)
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
	
	gettoken job jobrest: netexp, parse("(")
	local job = trim("`job'")
	local job = substr("`job'", 2,.)
	local selectjob : word 1 of `job'
	local selectjob "`selectjob'("
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
	
		nwrandom `nodes', prob(0) name(`netname') `undirected' `options' `xvars' `vars'
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
		local length = (strpos("`netexp'",")")) - `start' - 1
		local subopt = substr("`netexp'", `=`start' + 1', `length')
		
		/// NETWORK PRODUCING FUNCTIONS
		/////////
		
		// nwduplicate shortcut
		qui if "`whichjob'" == "duplicate(" {
			_nwsyntax `subopt', max(9999) name("othername")
			nwduplicate `subopt', name(`netname') `options'
		}	
		
		// nwduplicate shortcut
		qui if "`whichjob'" == "subset(" {
			_nwsyntax `subopt', max(9999) name("othername")
			nwsubset `subopt' `ifcond', name(`netname') `options'
		}

		// nwdyadprob shortcut
		qui if "`whichjob'" == "dyadprob(" {
			_nwsyntax `subopt', max(9999) name("othername")
			nwdyadprob `subopt', name(`netname') `options'
		}	
		
		// nwgeodesic shortcut
		qui if "`whichjob'" == "geodesic(" {
			_nwsyntax `subopt', max(9999) name("othername")
			nwgeodesic `subopt', name(`netname') `options'
		}
		// nwgeodesic shortcut
		qui if "`whichjob'" == "homophily(" {
			_nwsyntax `subopt', max(9999) name("othername")
			nwhomophily `subopt', name(`netname') `options'
		}
		// nwlattice shortcut
		qui if "`whichjob'" == "lattice(" {
			nwlattice `subopt', name(`netname') `options'
		}	
		// nwlattice shortcut
		qui if "`whichjob'" == "path(" {
			_nwsyntax `subopt', max(9999) name("othername")
			nwpath `subopt', name(`netname') `options'
		}
		// nwlattice shortcut
		qui if "`whichjob'" == "permute(" {
			_nwsyntax `subopt', max(9999) name("othername")
			nwpermute `subopt', name(`netname') `options'
		}	
		// nwpref shortcut
		qui if "`whichjob'" == "permute(" {
			nwpref `subopt', name(`netname') `options'
		}	
		// nwrandom shortcut
		qui if "`whichjob'" == "random(" {
			nwrandom `subopt', name(`netname') `options'
		}	
		// nwreach shortcut
		qui if "`whichjob'" == "reach(" {
			_nwsyntax `subopt', max(9999) name("othername")
			nwreach `subopt', name(`netname') `options'
		}	
		// nwring shortcut
		qui if "`whichjob'" == "ring(" {
			nwring `subopt', name(`netname') `options'
		}	
		// nwsmall shortcut
		qui if "`whichjob'" == "small(" {
			nwsmall `subopt', name(`netname') `options'
		}
		// nwtranspose shortcut
		qui if "`whichjob'" == "transpose(" {
			_nwsyntax `subopt', max(9999) name("othername")
			nwtranspose `subopt', name(`netname') `options'
		}	
		
		/// VARIABLE PRODUCING FUNCTIONS
		/////////
		
		// nwclustering shortcuts
		qui if "`whichjob'" == "clustering(" {
			nwclustering `subopt', gen(`netname') `options'
		}
		
		// nwcloseness shortcuts
		qui if "`whichjob'" == "closeness(" {
			tempvar _t1 _t2
			nwcloseness `subopt', gen(`netname' `_t1' `_t2') `options'
		}
		qui if "`whichjob'" == "farness(" {
			tempvar _t1 _t2
			nwcloseness `subopt', gen(`_t1' `netname' `_t2') `options'
		}
		qui if "`whichjob'" == "nearness(" {
			tempvar _t1 _t2
			nwcloseness `subopt', gen(`_t1' `_t2' `netname') `options'
		}
		
		// nwcomponents shortcuts
		if "`whichjob'" == "components(" {
			qui nwcomponents `subopt', gen(`netname') `options'
		}
		if "`whichjob'" == "lgc(" {
			qui nwcomponents `subopt', gen(`netname') lgc `options'
		}
		
		// nwdegree shortcuts
		qui if "`whichjob'" == "isolates(" {
			tempvar _t1 
			nwdegree `subopt', isolates gen(`_t1') `options'
			rename _isolate `netname' 
			capture drop *`_t1'
		}
		qui if "`whichjob'" == "indegree(" {
			tempvar _t1 
			nwdegree `subopt', gen(`netname' `_t1') `options'
			capture confirm variable _in`netname'
			if _rc == 0 {
				rename _in`netname' `netname'
				drop _out`netname'
			}
		}
		qui if "`whichjob'" == "outdegree(" {
			tempvar _t1
			nwdegree `subopt', gen(`netname' `_t1') `options'
			capture confirm variable _out`netname'
			if _rc == 0 {
				rename _out`netname' `netname'
				drop _in`netname'
			}
		}
		qui if "`whichjob'" == "degree(" {
			tempvar _t1
			nwdegree `subopt', gen(`netname' `_t1') `options'
			capture confirm variable _out`netname'
			if _rc == 0 {
				rename _out`netname' `netname'
				drop _in`netname'
			}
		}
		
		// nwbetween shortcuts
		if "`whichjob'" == "between(" {
			nwbetween `subopt', generate(`netname') `options'
		}
		
		// nwcontext shortcuts
		if "`whichjob'" == "context(" {
			nwcontext `subopt', generate(`netname') `options'
		}
		
		// nwevcent shortcuts
		if "`whichjob'" == "evcent(" {
			nwevcent `subopt', generate(`netname') `options'
		}
		
	}

	capture nwdrop _temp*
end

	
	
	
	
	
	

	
