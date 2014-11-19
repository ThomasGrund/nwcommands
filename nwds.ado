*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwds
program nwds, rclass
	 syntax [anything(name=netname)] , [alpha]
	 _nwsyntax , max(9999)
	 
	 if  !=  {
		local netname : list sort netname
	 }
	 
	 return local netlist = 
end
