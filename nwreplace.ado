capture program drop nwreplace
program nwreplace
	local arg ="`0'"
	gettoken netname nonet: arg, parse("=")
	local netname = trim("`netname'")

	// specific enrtries are given
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
	local id = r(id)
	
	// get rid of first equal sign
	local nonet = substr(trim("`nonet'"),2,.)
	
	// separate out conditions
	local inpos = strpos("`nonet'", " in ")
	local ifpos = strpos("`nonet'", " if ")
	local ifegopos = strpos("`nonet'", " ifego ")
	local ifalterpos = strpos("`nonet'"," ifalter ")
	
	if (`inpos' == 0) { 
		local inpos = "" 
	}
	if (`ifpos' == 0) { 
		local ifpos = "" 
	}
	if (`ifegopos' == 0) { 
		local ifegopos = "" 
	}
	if (`ifalterpos' == 0) { 
		local ifalterpos = "" 
	}
	capture numlist "`ifpos' `ifegopos' `ifalterpos' `inpos'", sort
	local condition "`r(numlist)'"
	local condlength = wordcount("`condition'")
	forvalues i = 1 / `condlength' {
		local w = word("`condition'", `i')
		if ("`w'" == "`inpos'"){
			local inend = word("`condition'", `=`i' + 1')'
			if "`inend'" == "" {
				local inend = "."
			}
			local incmd = substr("`nonet'", `=`inpos'  + 4', `=`inend' - `inpos' - 4')
		}
		if ("`w'" == "`ifpos'"){
			local ifend = word("`condition'", `=`i' + 1')
			if "`ifend'" == "" {
				local ifend = "."
			}
			local ifcmd = substr("`nonet'", `=`ifpos'  + 4', `=`ifend' - `ifpos' - 4')
		}
		if ("`w'" == "`ifegopos'"){
			local ifegoend = word("`condition'", `=`i' + 1')
			if "`ifegoend'" == "" {
				local ifegoend = "."
			}
			local ifegocmd = substr("`nonet'", `=`ifegopos'  + 7', `=`ifegoend' - `ifegopos' - 7')
		}
		if ("`w'" == "`ifalterpos'"){
			local ifalterend = word("`condition'", `=`i' + 1')
			if "`ifalterend'" == "" {
				local ifalterend = "."
			}
			local ifaltercmd = substr("`nonet'", `=`ifalterpos'  + 9', `=`ifalterend' - `ifalterpos' - 9')
		
		}
	}
	
	local firstcond = word("`condition'",1) 
	if "`firstcond'"=="" {
		local firstcond = "."
	}
	local netexp = substr("`nonet'",1, `firstcond') 
	
	// evaluate expression
	_nwevalnetexp `netexp' % _replacenet

	if (r(nodes)==1){
		mata: _replacenet = J(`nodes', `nodes', _replacenet[1,1]) 
	}
	
	// deal with conditions
	nwtomata `netname', mat(_oldnet)
	
	if "`ifcmd'" != "" {
		local ifcmd = "(`ifcmd')"	
		_nwevalnetexp `ifcmd' % _ifnet		
		mata: _replacenet =  (_oldnet :* (_ifnet :==0)) + (_replacenet :* _ifnet) 
		mata: mata drop _ifnet
	}
	
	if "`ifegocmd'" != "" {
		local ifegocmd = "(`ifegocmd')"
		_nwevalnetexp `ifegocmd' % _ifegonet	
		mata: _replacenet =  (_oldnet :* (_ifegonet :==0)) + (_replacenet :* _ifegonet) 
		mata: mata drop _ifegonet
	}
	
	if "`ifaltercmd'" != "" {
		local ifaltercmd = "(`ifaltercmd')"
		_nwevalnetexp `ifaltercmd' % _ifalternet	
		mata: _ifalternet = _ifalternet'
		mata: _replacenet =  (_oldnet :* (_ifalternet :==0)) + (_replacenet :* _ifalternet) 
		mata: mata drop _ifalternet
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
	if "`subset'" == "" {
		nwreplacemat `netname', newmat(_replacenet)
		if "`undirected'" != "" {
			nwname `netname', newdirected(false)
		}
		else {
			nwname `netname', newdirected(true)
		}
	}
	else {
		mata: nw_mata`id'`subset'= _replacenet`subset'
		nwsync
	}
	mata: mata drop _replacenet _oldnet 
	capture mata: mata drop onenet
	capture nwdrop __temp*
	nwname `netname'
	nwcompressobs
end

	
