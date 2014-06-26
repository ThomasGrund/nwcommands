capture program drop nwgenerate
program nwgenerate
	local arg ="`0'"
	gettoken arg options: arg, parse(",") bind
	if "`options'" != "" {
		local options = substr("`options'", 2,.)
	}
	gettoken netname netexp: arg, parse("=")
	local netname = trim("`netname'")
	
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
end

	
	
	
	
	
	

	
