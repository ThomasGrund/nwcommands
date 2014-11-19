*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop _nwevalnetexp
program _nwevalnetexp
	
	local arg = "_nwevalnetexp.ado, date(18nov2014) author(Thomas Grund) email(thomas.u.grund@gmail.com) version(1.0.4.1) other()"
	gettoken netexp result: arg, parse("%")
	// prepare result
	local result = trim(subinstr("", "%", "",.))
	
	// prepare netexp and perform basic syntax check
	local netexp = trim("")
	local lnet = length("") 
	local netexp = substr("", 1, )
	local netexp_raw = ""
	
	local parenthesisBalance = 0
	forvalues i = 1/{
		local charAt = substr("",,1)
		if ("" == "(") local parenthesisBalance =  + 1
		if ("" == ")") local parenthesisBalance =  - 1
	}
	if ("" == "" |  != 0){a
		di "{err}{it:netexp} empty or contains unmatched parentheses"
		error 6077
	}
	
	// check for simple non-network expressions
	capture mata: 
	if (_rc == 0) {
		mata:  = 
		mata: st_numscalar("r(nodes)", rows())
		local nodes = r(nodes)
	}
	else {
	
	/////////////////////////////
	//
	// parse and handle potential nw-generators
	//
	/////////////////////////////

	// left-align parenthesis
	forvalues k = 1/10 {
		local nonet = subinstr("","( ", "(",.)
	}
		
	// identify network generator commands
	local checkstring = ""
	local nw_start = strpos("","(_nw")
	local nwgenNum = 0
	
	while (!= 0) {
		local checkstring = substr("", ,.)
		local checkstring_length = length("")
		local balance = 0
		local i = 1
		while ( <= ) {
			local ch = substr("", , 1)
			if ("" == "(") local balance =  + 1
			if ("" == ")") local balance =  - 1
			if ( == 0) {
				local nwgenNum =  + 1
				local gencmd = substr("", 3, -3)
				local gencmdReplace = trim("_")
				local _tempnet = "_tempgen"
								
				// add identifier of new temporary network
				if (strpos("",",") != 0){
					local gencmd " name() xvars noreplace"
				}
				else {
					local gencmd ", name() xvars noreplace"
				}
				
				// check that a valididty of nw-generator and execute it 				local generator = word("", 1)
				local generator = word("",1)

				capture which 
				if (_rc == 0) {
					// networks before generator executed
					capture nwset
					local totalNetsBefore = r(networks)
					
					capture 
					// network after generator executed
					capture nwset
					local totalNetsAfter = r(networks)
					if ( == ) {
						local nwgenNum =  - 1
						local errorOccured = "errorGeneratorFailed"
						local errorCode = 6079
						local errorGenerator = ""
						continue, break
					}
				}
				else {	
					local nwgenNum =  - 1
					local errorOccured = "errorInvalidGenerator"
					local errorCode = 6078
					local errorGenerator = ""
					continue, break
				}
				
				// replace gencmd in netexp 
				local netexp = subinstr("", "", "",1)
				local checkstring = trim("")
				local checknext_len = length("") - 3
				local checknext = substr("",3,)
				local nw_start = strpos("","(_nw") + 2
				if ( == 2) local nw_start = 0
				local i =  + 1
			}
			local i =  + 1
		}
		if ("" != "") {
			continue, break
		}
	}	
	
	// executes an early cleanup in case an error occured generating temporary network
	if ("" != ""){	
		forvalues i = 1/ {
			nwdrop _tempgen
		}
		if "" == "errorInvalidGenerator" {
			di "{err}subcommand {bf:} is not a valid {it:nwgenerator}"
		}
		if "" == "errorGeneratorFailed" {
			di "{err}subcommand {bf:} failed to generate a network"
		}
		error 
	}
	
	/////////////////////////////
	//
	//
	/////////////////////////////
	
	// Deal with operators in netexp expression 
	local exp ""
	local stataVars = 0
	local netexp_mata ""
	
	// replace all other operators
	local exp = subinstr("","**"," matmult ",.)
	local exp = subinstr("","=="," :== ",.)
	local exp = subinstr("",">="," :grequ ",.)
	local exp = subinstr("","<="," :smequ ",.)	
	local exp = subinstr("",">"," :> ",.)
	local exp = subinstr("","<"," :< ",.)	
	local exp = subinstr("",":grequ"," :>= ",.)
	local exp = subinstr("",":smequ"," :<= ",.)	
	local exp = subinstr("","*"," :* ",.)
	local exp = subinstr("","/"," :/ ",.)
	local exp = subinstr("","(-"," (J(matanodes , matanodes , mataminus1) * ",.)
	local exp = subinstr("","-"," :- ",.)
	local exp = subinstr("","mataminus1","-1",.)
	local exp = subinstr("","+"," :+ ",.)
	local exp = subinstr("","&"," :& ",.)
	local exp = subinstr("","|"," :| ",.)
	local exp = subinstr("","("," ( ",.)
	local exp = subinstr("",")"," ) ",.)
	local exp = subinstr("","["," [ ",.)
	local exp = subinstr("","]"," ] ",.)
	local exp = subinstr("","::"," :: ",.)
	local exp = subinstr("",","," , ",.)
	local exp = subinstr("","!="," :!= ",.)
	local exp = subinstr(""," matmult "," * ",.)

	// cycle through expression words first to get number of maxAllowedNodes
	local exp_words = wordcount("")
	local exp_net = ""
	tokenize ""
	local maxAllowedNodes = 9999
	forvalues i = 1/ {
		local x ""
		mata: st_rclear()
		capture nwname 
		if (_rc == 0){
			local maxAllowedNodes = min(, r(nodes))
		}
	}
		
	// set number of nodes
	local nodes = 
	
	// cycle through words in netexp
	local exp = subinstr("", "matanodes", "",.)
	local exp_words = wordcount("")
	local exp_net = ""
	tokenize ""

	forvalues i = 1/ {
		local x ""
		local operators = "op round( exp( abs( sqrt( log( ln( J , * :!= :: [ ] :& :| :> :< :>= :<= :* :/ :== & | :- :+ ( )"
		local isoperator = (strpos("", "") > 0)
		local subnet = "[(1::),(1::)]"
		// word is not a number or operator
		if (real("")== . &  != 1 ){		
			local found = 0
			
			// word is a network
			capture nwname 
			local id = r(id)
			if (_rc == 0){	
				local found = 1
				local exp = subinword("", "", "nw_mata ",1)
			}
			
			// word is Stata _n or _N
			if ("" == "_n" | "" == "_N" ){
				local found = 1
				tempvar _ntemp
				gen  = 
				local exp = subinword("", "", "",.)
				local x = ""
			}
			
			// word is a Stata variable
			capture confirm variable 
			if (_rc == 0){
				local obsStata = _N
				local maxAllowedNodes = min(, )
				local nodes = 
				local found = 1
				local stataVars =  + 1
				mata: stataVar_ = st_data((1::),"")
				local exp = subinword("", "", "stataVar_",.)
			}
			
			// word is neither number, operator, nor network or variable
			if ( == 0) {
				if (strpos("","_nw") == 1){
					di "{err}{it:nwgenerator} {bf:} failed"
				}
				else {
					di "{err}{it:network} or {it:variable} {bf:} not found"
				}
				local errorOccued = "errorNetwork"
				continue, break
			}
		}
	}
	
	// executes an early cleanup in case a network cound not be found
	if ("" == "errorNetwork"){	
		forvalues i = 1/ {
			nwdrop _tempgen
		}
		error 6001	
	}
	local netexp_mata = ""

	// to handle single numbers
	local sub_exp = ""
	local subpos1 = 1
	local subnodes = 
	while ( != 0) {
		local subpos1 = strpos("","[")
		local subpos2 = strpos("","]")
		local subdiff =  -  + 1
		local sub = trim(substr("", ,))
		local subcomma = strpos("", ",")
		local subend1 =  - 2
		local substart2 =  + 1
		local sublen2 = length("") - 
		local sub1 = substr("",2,)
		local sub2 = substr("", , )
		if ( != 0) {
			local sub1 = "()"
			local sub2 = "()"
			mata: st_numscalar("r(sub1)", rows())
			mata: st_numscalar("r(sub2)", rows())
			local subwords1 = wordcount("")
			local subnodes = min(, )
			local subnodes = min(, )
			// invalid subnet
			if r(sub1) != r(sub2) {
				local subprint = subinstr(""," ","",.)
				di "{err}{it:subnet} {bf:} not square"
				local errorOccured = "errorSubnet"
				continue, break
			}
		}
		
		local nextsubstart =  + 1
		local sub_exp = substr("",,.)		
	}
	
	
	// invoke early cleanup because of subnet failure
	if "" == "errorSubnet" {
		forvalues j= 1/ {
			mata: mata drop stataVar_
		}
	
		forvalues i = 1/ {
			nwdrop _tempgen
		}
		error 6500
	}
	
	local netexp_mata = " J(,,1) :* "
	local matacmd ""
	//di "Mata: "
	// execute network expression in mata
	if ("" != ""){
		capture mata: mata drop 
		mata:  = 
	}
	
	/////////////////////////////
	//
	// clean up 
	//
	/////////////////////////////
	forvalues j= 1/ {
		mata: mata drop stataVar_
	}
	
	forvalues i = 1/ {
		nwdrop _tempgen
	}
	}
	mata: st_rclear()
	mata: st_numscalar("r(nodes)", )
	mata: st_global("r(mat)", "")
	mata: st_global("r(netexp)","")
	
end
