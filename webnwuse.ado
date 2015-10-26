*! Date        : 23oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

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
		nwuse_old `webname', `options'
	}
	else {
		nwuse_old `thispath'/`webname', `options'
	}
	qui nwload, labelonly
end
