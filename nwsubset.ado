capture program drop nwsubset
program nwsubset
	version 9
	syntax [ anything(name=netname)] [if] [, name(string) xvars replace]
	_nwsyntax `netname', max(1)
	
	if "`name'" == "" {
		local name "`netname'_sub"
	}
	
	nwvalidate `name'
	local name = r(validname)

	nwname `netname'
	nwgenerate `name' = `netname', `xvars' vars(`r(vars)') labs(`r(labs)')
	if "`if'" != "" {
		capture nwkeep `name' `if'
	}
	if "`replace'" != "" {
		nwdrop `netname'
		nwrename `name' `netname'
	}
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
