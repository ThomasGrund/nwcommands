capture program drop _nwevalnetexp
program _nwevalnetexp
	syntax [anything] [, nodes(string)]
	local mynodes = "`nodes'"
	local arg = "`anything'"
	gettoken netexp result: arg, parse("%")
	
	// prepare result
	local result = trim(subinstr("`result'", "%", "",.))
	
	// prepare netexp and perform basic syntax check
	local netexp = trim("`netexp'")
	local lnet = length("`netexp'") 
	local netexp = substr("`netexp'", 1, `lnet')
	local netexp_raw = "`netexp'"
	
	local parenthesisBalance = 0
	forvalues i = 1/`lnet'{
		local charAt = substr("`netexp'",`i',1)
		if ("`charAt'" == "(") local parenthesisBalance = `parenthesisBalance' + 1
		if ("`charAt'" == ")") local parenthesisBalance = `parenthesisBalance' - 1
	}
	if ("`netexp'" == "" | `parenthesisBalance' != 0){a
		di "{err}{it:netexp} empty or contains unmatched parentheses"
		error 6077
	}
	
	// check for simple non-network expressions
	capture mata: `netexp'
	if (_rc == 0) {
		mata: `result' = `netexp'
		mata: st_numscalar("r(nodes)", rows(`result'))
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
		local nonet = subinstr("`netexp'","( ", "(",.)
	}
		
	// identify network generator commands
	local checkstring = "`netexp'"
	local nw_start = strpos("`checkstring'","(_nw")
	local nwgenNum = 0
	
	while (`nw_start'!= 0) {
		local checkstring = substr("`checkstring'", `nw_start',.)
		local checkstring_length = length("`checkstring'")
		local balance = 0
		local i = 1
		while (`i' <= `checkstring_length') {
			local ch = substr("`checkstring'", `i', 1)
			if ("`ch'" == "(") local balance = `balance' + 1
			if ("`ch'" == ")") local balance = `balance' - 1
			if (`balance' == 0) {
				local nwgenNum = `nwgenNum' + 1
				local gencmd = substr("`checkstring'", 3, `=`i'-3')
				local gencmdReplace = trim("_`gencmd'")
				local _tempnet = "_tempgen`nwgenNum'"
								
				// add identifier of new temporary network
				if (strpos("`gencmd'",",") != 0){
					local gencmd "`gencmd' name(`_tempnet') xvars noreplace"
				}
				else {
					local gencmd "`gencmd', name(`_tempnet') xvars noreplace"
				}
				
				// check that a valididty of nw-generator and execute it 				local generator = word("`gencmd'", 1)
				local generator = word("`gencmd'",1)

				capture which `generator'
				if (_rc == 0) {
					// networks before generator executed
					capture nwset
					local totalNetsBefore = r(networks)
					
					capture `gencmd'
					// network after generator executed
					capture nwset
					local totalNetsAfter = r(networks)
					if (`totalNetsBefore' == `totalNetsAfter') {
						local nwgenNum = `nwgenNum' - 1
						local errorOccured = "errorGeneratorFailed"
						local errorCode = 6079
						local errorGenerator = "`gencmd'"
						continue, break
					}
				}
				else {	
					local nwgenNum = `nwgenNum' - 1
					local errorOccured = "errorInvalidGenerator"
					local errorCode = 6078
					local errorGenerator = "`generator'"
					continue, break
				}
				
				// replace gencmd in netexp 
				local netexp = subinstr("`netexp'", "`gencmdReplace'", "`_tempnet'",1)
				local checkstring = trim("`checkstring'")
				local checknext_len = length("`checkstring'") - 3
				local checknext = substr("`checkstring'",3,`checknext_len')
				local nw_start = strpos("`checknext'","(_nw") + 2
				if (`nw_start' == 2) local nw_start = 0
				local i = `checkstring_length' + 1
			}
			local i = `i' + 1
		}
		if ("`errorOccured'" != "") {
			continue, break
		}
	}	
	
	// executes an early cleanup in case an error occured generating temporary network
	if ("`errorOccured'" != ""){	
		forvalues i = 1/`nwgenNum' {
			nwdrop _tempgen`i'
		}
		if "`errorOccured'" == "errorInvalidGenerator" {
			di "{err}subcommand {bf:`errorGenerator'} is not a valid {it:nwgenerator}"
		}
		if "`errorOccured'" == "errorGeneratorFailed" {
			di "{err}subcommand {bf:`errorGenerator'} failed to generate a network"
		}
		error `errorCode'
	}
	
	/////////////////////////////
	//
	//
	/////////////////////////////
	
	// Deal with operators in netexp expression 
	local exp "`netexp'"
	local stataVars = 0
	local netexp_mata ""
	
	// replace all other operators
	local exp = subinstr("`exp'","**"," matmult ",.)
	local exp = subinstr("`exp'","=="," :== ",.)
	local exp = subinstr("`exp'",">="," :grequ ",.)
	local exp = subinstr("`exp'","<="," :smequ ",.)	
	local exp = subinstr("`exp'",">"," :> ",.)
	local exp = subinstr("`exp'","<"," :< ",.)	
	local exp = subinstr("`exp'",":grequ"," :>= ",.)
	local exp = subinstr("`exp'",":smequ"," :<= ",.)	
	local exp = subinstr("`exp'","*"," :* ",.)
	local exp = subinstr("`exp'","/"," :/ ",.)
	local exp = subinstr("`exp'","(-"," (J(matanodes , matanodes , mataminus1) * ",.)
	local exp = subinstr("`exp'","-"," :- ",.)
	local exp = subinstr("`exp'","mataminus1","-1",.)
	local exp = subinstr("`exp'","+"," :+ ",.)
	local exp = subinstr("`exp'","&"," :& ",.)
	local exp = subinstr("`exp'","|"," :| ",.)
	local exp = subinstr("`exp'","("," ( ",.)
	local exp = subinstr("`exp'",")"," ) ",.)
	local exp = subinstr("`exp'","["," [ ",.)
	local exp = subinstr("`exp'","]"," ] ",.)
	local exp = subinstr("`exp'","::"," :: ",.)
	local exp = subinstr("`exp'",","," , ",.)
	local exp = subinstr("`exp'","!="," :!= ",.)
	local exp = subinstr("`exp'"," matmult "," * ",.)

	// cycle through expression words first to get number of maxAllowedNodes
	local exp_words = wordcount("`exp'")
	local exp_net = "`exp'"
	tokenize "`exp_net'"
	local maxAllowedNodes = 9999
	forvalues i = 1/`exp_words' {
		local x "``i''"
		mata: st_rclear()
		capture nwname `x'
		if (_rc == 0){
			local maxAllowedNodes = min(`maxAllowedNodes', r(nodes))
		}
	}
	
	// set number of nodes
	local nodes = `maxAllowedNodes'
	
	// cycle through words in netexp
	local exp = subinstr("`exp'", "matanodes", "`nodes'",.)
	local exp_words = wordcount("`exp'")
	local exp_net = "`exp'"
	
	tokenize "`exp_net'"

	forvalues i = 1/`exp_words' {
		local x "``i''"
		local operators = "op round( exp( abs( sqrt( log( ln( J , * :!= :: [ ] :& :| :> :< :>= :<= :* :/ :== & | :- :+ ( )"
		local isoperator_match : list operators & x
		local isoperator = wordcount("`isoperator_match'")		
		
		//(strpos("`operators'", "`x'") > 0)
		local subnet = "[(1::`nodes'),(1::`nodes')]"
		// word is not a number or operator
		if (real("`x'")== . & `isoperator' != 1 ){		
			local found = 0
			
			// word is a network
			capture nwname `x'
			local id = r(id)
			if (_rc == 0){	
				local found = 1
				local exp = subinword("`exp'", "`x'", "nw_mata`id'`subnet' ",1)
			}
			
			// word is Stata _n or _N
			if ("`x'" == "_n" | "`x'" == "_N" ){
				local found = 1
				tempvar _ntemp
				gen `_ntemp' = `x'
				local exp = subinword("`exp'", "`x'", "`_ntemp'",.)
				local x = "`_ntemp'"
			}
			
			// word is a Stata variable
			capture confirm variable `x'
			if (_rc == 0){
				local obsStata = _N
				local maxAllowedNodes = min(`obsStata', `nodes')
				local nodes = `maxAllowedNodes'
				local found = 1
				local stataVars = `stataVars' + 1
				mata: stataVar_`stataVars' = st_data((1::`nodes'),"`x'")
				local exp = subinword("`exp'", "`x'", "stataVar_`stataVars'",.)
			}
			
			/*
			// word is neither number, operator, nor network or variable
			if (`found' == 0) {
				if (strpos("`x'","_nw") == 1){
					di "{err}{it:nwgenerator} {bf:`x'} failed"
				}
				else {
					di "{err}{it:network} or {it:variable} {bf:`x'} not found"
				}
				local errorOccued = "errorNetwork"
				continue, break
			}*/
		}
	}
	
	// executes an early cleanup in case a network cound not be found
	if ("`errorOccured'" == "errorNetwork"){	
		forvalues i = 1/`nwgenNum' {
			nwdrop _tempgen`i'
		}
		error 6001	
	}
	local netexp_mata = "`exp'"

	// to handle single numbers
	local sub_exp = "`exp'"
	local subpos1 = 1
	local subnodes = `nodes'
	while (`subpos1' != 0) {
		local subpos1 = strpos("`sub_exp'","[")
		local subpos2 = strpos("`sub_exp'","]")
		local subdiff = `subpos2' - `subpos1' + 1
		local sub = trim(substr("`sub_exp'", `subpos1',`subdiff'))
		local subcomma = strpos("`sub'", ",")
		local subend1 = `subcomma' - 2
		local substart2 = `subcomma' + 1
		local sublen2 = length("`sub'") - `substart2'
		local sub1 = substr("`sub'",2,`subend1')
		local sub2 = substr("`sub'", `substart2', `sublen2')
		if (`subpos1' != 0) {
			local sub1 = "(`sub1')"
			local sub2 = "(`sub2')"
			mata: st_numscalar("r(sub1)", rows(`sub1'))
			mata: st_numscalar("r(sub2)", rows(`sub2'))
			local subwords1 = wordcount("`sub1'")
			local subnodes = min(`subnodes', `r(sub1)')
			local subnodes = min(`subnodes', `r(sub2)')
			// invalid subnet
			if r(sub1) != r(sub2) {
				local subprint = subinstr("`sub'"," ","",.)
				di "{err}{it:subnet} {bf:`subprint'} not square"
				local errorOccured = "errorSubnet"
				continue, break
			}
		}
		
		local nextsubstart = `subpos2' + 1
		local sub_exp = substr("`sub_exp'",`nextsubstart',.)		
	}
	
	// invoke early cleanup because of subnet failure
	if "`errorOccured'" == "errorSubnet" {
		forvalues j= 1/`stataVars' {
			mata: mata drop stataVar_`j'
		}
	
		forvalues i = 1/`nwgenNum' {
			nwdrop _tempgen`i'
		}
		error 6500
	}
	
	local netexp_mata = " J(`subnodes',`subnodes',1) :* `netexp_mata'"
	local matacmd "`netexp_mata'"
	
	//di "Mata: `matacmd'"

	// execute network expression in mata
	if ("`result'" != ""){
		capture mata: mata drop `result'
		mata: `result' = `matacmd'
	
		if "`mynodes'" != "" {
			mata: `result' = getResultWithNodes(`result', `mynodes')
		}
	}

	
	/////////////////////////////
	//
	// clean up 
	//
	/////////////////////////////
	forvalues j= 1/`stataVars' {
		mata: mata drop stataVar_`j'
	}
	
	forvalues i = 1/`nwgenNum' {
		nwdrop _tempgen`i'
	}
	}
	mata: st_rclear()
	mata: st_numscalar("r(nodes)", `nodes')
	mata: st_global("r(mat)", "`result'")
	mata: st_global("r(netexp)","`netexp_raw'")
	
end

capture mata : mata drop getResultWithNodes()
mata: 
real matrix getResultWithNodes(real matrix res, scalar nodes) {
	
	if (nodes < rows(res)){
		res = res[(1::nodes), (1::nodes)]
	}
	if (nodes > rows(res)){
		result2 = J(nodes, nodes, 0)
		
		result2[(1::rows(res)), (1::cols(res))] = res
		res = result2
	}
	return(res)
}
end



