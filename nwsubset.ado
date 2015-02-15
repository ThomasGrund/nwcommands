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
