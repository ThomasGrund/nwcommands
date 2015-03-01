*! Date        : 3sept2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop webnwuse
program webnwuse
	syntax anything [, * nwclear]
	
	`nwclear'
	capture drop _running 
	
	local subcommand = word("`anything'",1)
	local path = "\$nwwebpath"
	local thispath = "`path'"
	
	if "`subcommand'" != "set" {
		if "`thispath'" == "" | "`thispath'" == "\" {
			global nwwebpath = "http://nwcommands.org/data"
		}
	}
	
	if "`subcommand'" == "set" {
		local subcmd2 = word("`anything'",2)
		if  "`subcmd2'" == "" {
			global nwwebpath = "http://nwcommands.org/data"
		}
		else {
			global nwwebpath = word("`anything'",2)
		}
		exit
	}
	if "`subcommand'" == "query" {
		di `"{txt}(prefix now "{bf:$nwwebpath}")"'
		exit
	}
	
	local path = "\$nwwebpath"
	local thispath = "`path'"
	
	local webname = subinstr("`anything'", ".dta","",99)
	if substr("`webname'",1,4) == "http" {
		nwuse `webname', `options'
	}
	else {
		nwuse `thispath'/`webname', `options'
	}
	qui nwload, labelonly
end



	

