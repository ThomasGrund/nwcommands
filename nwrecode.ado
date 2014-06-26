capture program drop nwrecode
program nwrecode
	version 9
	syntax [anything(name=arg)] [if/], [newvalue(string)]
	
	qui nwset
	if "`arg'" == "" {
		exit
	}
	
	gettoken next arg: arg, bind
	local onenet = "`next'"
	qui capture nwname `next'
	
	if _rc != 0 {
		nwcurrent
		local onenet = r(current)
	}
	else {
		gettoken next arg: arg, bind
	}
	
	nwtomata `onenet', mat(recodeNet)

	while "`next'" != "" {
		// Parse rules
		// Get rid of brackets
		local rule = subinstr("`next'", "(","",.)
		local rule = subinstr("`rule'",")","",.)
	
		gettoken leftside rightside: rule, parse("=")
		local rightside = subinstr("`rightside'","=","",.)
		if wordcount("`rightside'") != 1 {
			di "{err}Recoding rule wrongly specified."
			error 6077
		}
	
		numlist "`leftside'"
		local leftside = r(numlist)
	
		di "L: `leftside'"
		di "R: `rightside'"
	
		foreach value in `leftside' {
			local newvalue = `rightside' * 10000
			mata: _editvalue(recodeNet, `value', `newvalue')
		}
		gettoken next arg: arg, bind	
	}
	
	// Clean up if expression.
	
	mata: recodeNet = (recodeNet :> 1000) * recodeNet :/ 10000 
	
	nwreplace `onenet', newmat(recodeNet)
	mata: mata drop recodeNet
	
end
