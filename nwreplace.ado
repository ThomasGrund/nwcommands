capture program drop nwreplace
program nwreplace
	local arg ="`0'"
	gettoken netname nonet: arg, parse("=")
	local netname = trim("`netname'")

	// a specific enrtries are given
	local ego = strpos("`netname'","[") 
	local alter = strpos("`netname'","]") 
	local sep = strpos("`netname'",",")
	local subset = substr("`netname'",`ego',.)
	if (`ego' != 0) {
		local e1 = `ego' + 1
		local e2 = `sep' - `ego' - 1
		local a1 =  `sep' + 1
		local a2 = `alter' - `sep' - 1
		local n1 = `ego' - 1
		local egoid = substr("`netname'", `e1', `e2')
		local alterid = substr("`netname'", `a1', `a2')
		local netname = substr("`netname'", 1, `n1')
	}
	
	nwtomata `netname', mat(onenet)
	local matacmd "mata: onenet`subset'"
	capture `matacmd'
	if _rc != 0 {
		di "{err}{it:nwsubset} {bf:`subset'} invalid"
		error 6400
	}
	
	if "`netname'" == "=" {
		di "{err}{it:networkname} required before ="
		error 6001
	}
	nwname `netname'
	local nodes = r(nodes)
	local directed = r(directed)
	
	// get rid of first equal sign
	local nonet = substr(trim("`nonet'"),2,.)
	
	// separate out in condition
	local inpos = strpos("`nonet'", " in ")
	local nonetNoin "`nonet'"
	if (`inpos' > 0){
		local nonetNoin = substr("`nonet'",1,`inpos')
		local incmd = substr("`nonet'", `=`inpos' + 4',.)
	}

	// separate out if condition
	local ifpos = strpos("`nonetNoin'", " if ")
	local netexp "`nonetNoin'"
	if (`ifpos' > 0){
		local netexp = substr("`nonetNoin'",1,`ifpos')
		local ifcmd = substr("`nonetNoin'", `=`ifpos' + 4',.)
	}
	
	// evaluate expression
	_nwevalnetexp `netexp' % _replacenet

	if (r(nodes)==1){
		mata: _replacenet = J(`nodes', `nodes', _replacenet[1,1]) 
	}
	
	// deal with if condition
	nwtomata `netname', mat(_oldnet)
	
	if "`ifcmd'" != "" {
		local ifcmd = "(`ifcmd')"
		_nwevalnetexp `ifcmd' % _ifnet
		mata: _replacenet =  (_oldnet :* (_ifnet :==0)) + (_replacenet :* _ifnet) 
		mata: mata drop _ifnet
	}
	
	// deal with in condition
	if (trim("`incmd'") != ""){
		// validate incmd
		local 0 "in `incmd'"
		syntax [in/]
		tempvar invarinv 
		gen `invarinv' = 1
		replace `invarinv' = 0 in `incmd'	
		mata: _invarinv = st_data((1::`nodes'),"`invarinv'")
		mata: _editmissing(_oldnet,0)
		mata: _inoldmat = _oldnet :* _invarinv
		mata: _replacenet = _replacenet :* ((_invarinv :-1):*-1) 
		mata: _replacenet = _replacenet :+ _inoldmat
		mata: mata drop _inoldmat _invarinv
	}
	
	// deal with ego/alter selection
	if (`ego' != 0) {
		mata: _selection = _oldnet
		mata: _selection[`egoid',`alterid'] = _replacenet[`egoid',`alterid']
		mata: _replacenet = _selection
		mata: mata drop _selection
		
	}
	
	// check if new network is directed
	mata: st_numscalar("r(sym)", issymmetric(_replacenet))
	if (r(sym) == 1){
		local undirected "undirected"
	}
	nwreplacemat `netname', newmat(_replacenet)
	if "`undirected'" != "" {
		nwname `netname', newdirected(false)
	}
	else {
		nwname `netname', newdirected(true)
	}
	mata: mata drop _replacenet _oldnet 
	capture mata: mata drop onenet
	nwname `netname'
	nwcompressobs
end

	
