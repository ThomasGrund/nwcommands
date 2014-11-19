*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwtomata
program nwtomata
version 9
syntax [anything(name=netname)], mat(string)
	if  ==  {
		local mat network
	}
	capture _nwsyntax , max(1)
	if (_rc == 0){
		mata:  = nw_mata
	}
	else {
		capture unab netname : 
		capture confirm variable 
		if (_rc == 0){
			unab vars: 
			local size : word count 
			mata:  = st_data((1::),tokens())
		}
	}
 end
 
