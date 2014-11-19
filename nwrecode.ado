*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwrecode
program nwrecode
	version 9
	syntax [anything(name=arg)] [if/], [newvalue(string)]
	
	qui nwset
	if "" == "" {
		exit
	}
	
	gettoken next arg: arg, bind
	local onenet = ""
	qui capture nwname 
	
	if _rc != 0 {
		nwcurrent
		local onenet = r(current)
	}
	else {
		gettoken next arg: arg, bind
	}
	
	nwtomata , mat(recodeNet)

	while "" != "" {
		// Parse rules
		// Get rid of brackets
		local rule = subinstr("", "(","",.)
		local rule = subinstr("",")","",.)
	
		gettoken leftside rightside: rule, parse("=")
		local rightside = subinstr("","=","",.)
		if wordcount("") != 1 {
			di "{err}Recoding rule wrongly specified."
			error 6077
		}
	
		numlist ""
		local leftside = r(numlist)
	
		di "L: "
		di "R: "
	
		foreach value in  {
			local newvalue =  * 10000
			mata: _editvalue(recodeNet, , )
		}
		gettoken next arg: arg, bind	
	}
	
	// Clean up if expression.
	
	mata: recodeNet = (recodeNet :> 1000) * recodeNet :/ 10000 
	
	nwreplace , newmat(recodeNet)
	mata: mata drop recodeNet
	
end
