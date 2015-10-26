*! Date        : 25oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwduplicate
program nwduplicate
	syntax [anything(name=netname)], [name(string) xvars]
	unw_defs	
	nw_syntax `netname', max(1)
	
	if "`name'" == "" {
		local name "`netname'_copy"
	}
	nwvalidate `name'
	mata: `nws'.duplicate("`netname'", "`r(validname)'")
end

