*! Date        : 3sept2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

capture program drop webnwuse
program webnwuse
	syntax anything [, *]
	local webname = subinstr("`anything'", ".dta","",99)
	nwuse http://nwcommands.org/data/`webname', `options'
end



	

