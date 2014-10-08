capture program drop nwgenerate
program nwgenerate
	local arg ="`0'"
	gettoken arg options: arg, parse(",") bind
	if "`options'" != "" {
		local options = substr("`options'", 2,.)
	}
	gettoken netname netexp: arg, parse("=")
	local netname = trim("`netname'")
	
	// check if network or variable should be created
	
	gettoken job jobrest: netexp, parse("(")
	local job = trim("`job'")
	local job = substr("`job'", 2,.)
	local selectjob : word 1 of `job'
	local nwgenopt "evcent context degree outdegree indegree isolates components lgc clustering closeness farness nearness between"
	local whichjob : list  nwgenopt & selectjob
	local nwgenvar : word count `whichjob'
	
	// generate network
	if `nwgenvar' == 0 {
	
		// replace the network if it exists already
		if (strpos("`options'", "replace")!=0){
			capture nwdrop `netname'
		}
	
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
		nwrandom `nodes', prob(0) name(`netname') `undirected' `options'
		nwreplacemat `netname', newmat(_genmat)
	
		mata: st_rclear()
		nwname `netname'
		mata: st_global("r(netexp)", "`netexp'")
		mata: mata drop _genmat
	}
	// generate variable
	qui else {
		// get whatever is inside parenthesis
		local start = strpos("`netexp'", "(")
		local length = (strpos("`netexp'",")")) - `start' - 1
		local subopt = substr("`netexp'", `=`start' + 1', `length')
		
		// nwclustering shortcuts
		if "`whichjob'" == "clustering" {
			nwclustering `subopt', gen(`netname')
		}
		
		// nwcloseness shortcuts
		if "`whichjob'" == "closeness" {
			tempvar _t1 _t2
			nwcloseness `subopt', gen(`netname' `_t1' `_t2') `options'
		}
		if "`whichjob'" == "farness" {
			tempvar _t1 _t2
			nwcloseness `subopt', gen(`_t1' `netname' `_t2') `options'
		}
		if "`whichjob'" == "nearness" {
			tempvar _t1 _t2
			nwcloseness `subopt', gen(`_t1' `_t2' `netname') `options'
		}
		
		// nwcomponents shortcuts
		if "`whichjob'" == "components" {
			nwcomponents `subopt', gen(`netname') `options'
		}
		if "`whichjob'" == "lgc" {
			nwcomponents `subopt', gen(`netname') lgc `options'
		}
		
		// nwdegree shortcuts
		if "`whichjob'" == "isolates" {
			tempvar _t1 _t2 _t3
			nwdegree `subopt', isolates gen(`_t1' `_t2' `_t3' `netname') `options'
		}
		if "`whichjob'" == "indegree" {
			tempvar _t1 _t2 _t3
			nwdegree `subopt', gen(`_t1' `_t2' `netname' `_t3') `options'
			capture confirm variable `netname'
			if _rc != 0 {
				nwdegree `subopt', gen(`netname' `_t1' `_t2' `_t3') `options'
			}
		}
		if "`whichjob'" == "outdegree" {
			tempvar _t1 _t2 _t3
			nwdegree `subopt', gen(`_t1' `netname' `_t2'  `_t3') `options'
			capture confirm variable `netname'
			if _rc != 0 {
				nwdegree `subopt', gen(`netname' `_t1' `_t2' `_t3') `options'
			}
		}
		if "`whichjob'" == "degree" {
			tempvar _t1 _t2 _t3
			nwdegree `subopt', gen(`netname' `_t1' `_t2'  `_t3') `options'
			capture confirm variable `netname'
			if _rc != 0 {
				nwdegree `subopt', gen(`_t1' `netname' `_t2' `_t3') `options'
			}
		}
		
		// nwbetween shortcuts
		if "`whichjob'" == "between" {
			nwbetween `subopt', gen(`netname') `options'
		}
		
		// nwcontext shortcuts
		if "`whichjob'" == "context" {
			nwcontext `subopt', gen(`netname') `options'
		}
		
		// nwevcent shortcuts
		if "`whichjob'" == "evcent" {
			nwevcent `subopt', gen(`netname') `options'
		}
		
	}
end

	
	
	
	
	
	

	
