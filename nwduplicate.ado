capture program drop nwduplicate
program nwduplicate
	version 9
	syntax [anything(name=netname)], [name(string) xvars]
		
	_nwsyntax `netname', max(1)
	
	if "`name'" == "" {
		local name "`netname'_copy"
	}
	nwvalidate `name'
	local name = r(validname)
	nwname `netname'
	nwgenerate `name' = `netname', `xvars' vars(`r(vars)') labs(`r(labs)')
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
