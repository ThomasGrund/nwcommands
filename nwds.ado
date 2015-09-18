capture program drop nwds
program nwds, rclass
	 syntax [anything(name=netname)] , [alpha not *]

	 if "`t'" != "" {
		_nwsyntax_other _all, max(9999)
		local netname : list othername - netname
	 }
	 
	 if "`netname'" == "" {
		local netname = "_all"
	 }
	 _nwsyntax `netname', max(9999)
	 if "`alpha'" != "" {
		local netname : list sort netname
	 }
	 preserve
	 clear
	 foreach v in `netname' {
		gen `v' = .
	 }
	 ds `netname', `alpha' `options'
	 restore
	 return local netlist "`netname'"
end
*! v1.5.0 __ 17 Sep 2015 __ 13:09:53
*! v1.5.1 __ 17 Sep 2015 __ 14:54:23
