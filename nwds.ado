capture program drop nwds
program nwds, rclass
	 syntax [anything(name=netname)] , [alpha]
	 _nwsyntax `netname', max(9999)
	 
	 if "`alpha'" != "" {
		local netname : list sort netname
	 }
	 
	 return local netlist = "`netname'"
end
